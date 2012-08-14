//
//  ServerRequest.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

@implementation ServerRequest

@synthesize responseData = responseData_;
@synthesize responseBlock = responseBlock_;
@synthesize statusCode = statusCode_;
@synthesize startDate = startDate_;
@synthesize urlRequest = urlRequest_;
@synthesize hasFinished;

- (void)createConnection:(NSMutableURLRequest *)withRequest usingBlock:(ServerResponseBlock)inBlock {
	self.responseBlock = inBlock;
	self.urlRequest = withRequest;
    self.hasFinished = NO;
    
	NSLog(@"ServerRequest - Init: %@ %@", [withRequest HTTPMethod], [[withRequest URL] absoluteString]);
	
	if([[withRequest HTTPMethod] isEqualToString:@"POST"]) {
		NSString *data = [[NSString alloc] initWithData:[withRequest HTTPBody] encoding:NSUTF8StringEncoding];
		
		if([data length] > 250) {
			NSLog(@"ServerRequest - Init POST Body: %@", [NSString stringWithFormat:@"%@...", [data substringToIndex:250]]);
		} else {
			NSLog(@"ServerRequest - Init POST Body: %@", data);
		}
	}
	
	self.startDate = [NSDate date];
	[self createUrlConnection:withRequest];
}

- (void)createUrlConnection:(id)withRequest  {
	if([[NSThread currentThread] isMainThread]) {
		connection_ = [[NSURLConnection alloc] initWithRequest:withRequest delegate:self];
	} else {
		[self performSelectorOnMainThread:@selector(createUrlConnection:) withObject:withRequest waitUntilDone:NO];
	}
}

- (void)cancelRequest {
    if(!self.hasFinished) {
        [connection_ cancel];
        NSLog(@"ServerRequest - Cancelled Request");
    }
}

- (NSMutableData *)responseData {
	if(!responseData_) {
		responseData_ = [[NSMutableData alloc] init];
	}
	
	return responseData_;
}

#pragma mark NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	statusCode_ = [httpResponse statusCode];
    
	NSLog(@"ServerRequest (%@) - Status code: %@", [[urlRequest_ URL] absoluteString], [NSNumber numberWithInt:[httpResponse statusCode]]);
	
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Show error
	NSLog(@"ServerRequest (%@) - Connection error: %@", [[urlRequest_ URL] absoluteString], [error description]);
	self.hasFinished = YES;
    
	if(self.responseBlock != nil) {
		self.responseBlock(nil,error);
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSTimeInterval runTime = -[self.startDate timeIntervalSinceNow];
	NSLog(@"ServerRequest (%@) - Connection finished, took %f seconds", [[urlRequest_ URL] absoluteString], runTime);
	self.hasFinished = YES;
    
	// Send a failure for all non-200 status codes
	if(self.statusCode/100 != 2) {
		if(self.responseBlock != nil) {
			self.responseBlock(nil,[NSError errorWithDomain:@"ServerRequest" code:self.statusCode userInfo:[NSDictionary dictionaryWithObject:@"Error. Non-200 status code." forKey:@"userInfo"]]);
		}
	} else if(self.responseBlock != nil) {
		self.responseBlock(self.responseData,nil);
	}
}

#pragma mark NSURLConnectionDelegate Methods

/*
 *	These two methods allow the request to continue even if invalid certificates are encountered.
 *	This is needed for the OAuth requests to connect mail / social services
 */
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
