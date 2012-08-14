//
//  ServerRequest.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ServerResponseBlock)(NSData *,NSError *);

@interface ServerRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
	NSURLConnection		*connection_;
	NSMutableData		*responseData_;
	ServerResponseBlock	responseBlock_;
	NSInteger			statusCode_;
	NSMutableURLRequest		*urlRequest_;
	NSDate				*startDate_;
}

@property (nonatomic, readwrite, retain)	NSMutableURLRequest		*urlRequest;
@property (nonatomic, readwrite, retain)	NSMutableData		*responseData;
@property (nonatomic, copy)					ServerResponseBlock	responseBlock;
@property (nonatomic, readonly, assign)		NSInteger			statusCode;
@property (nonatomic, readwrite, retain)	NSDate				*startDate;
@property (nonatomic, assign)               BOOL				hasFinished;

- (void)createConnection:(NSMutableURLRequest *)withRequest usingBlock:(ServerResponseBlock)inBlock;
- (void)createUrlConnection:(id)withRequest;
- (void)cancelRequest;

@end