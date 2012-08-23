//
//  PersonViewController.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"
#import "ServerRequest.h"
#import "ADNConnect.h"
#import "SBJson.h"
#import "DetailTableViewCell.h"

@interface PersonViewController ()
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property(strong, nonatomic) NSDictionary *personData;
@property(strong, nonatomic) ServerRequest *photoRequest;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIImage *userPicture;
@end

@implementation PersonViewController

@synthesize personID, personData, spinner, name, avatar, followers, following, description, photoRequest, userPicture;
@synthesize tableView, posts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.posts = [NSArray array];
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (void)dealloc {
	if(self.photoRequest) {
        [self.photoRequest cancelRequest];
    }
    self.photoRequest = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.spinner setCenter:CGPointMake(self.view.frame.origin.x/2, self.view.frame.origin.y/2)];
	[self.view addSubview:self.spinner];
	
	[self.spinner startAnimating];
	[self retrievePersonData];
    [self retrievePersonPosts];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)retrievePersonData {
 	// Start loading the posts
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ADNConnect userUrl:self.personID]]];
	
	ServerRequest* serverConnect = [[ServerRequest alloc] init];
	[serverConnect createConnection:request usingBlock:^(NSData *responseData, NSError *error) {
		[self.spinner stopAnimating];
		
		if(!responseData || error) {
			NSLog(@"Error!  No response data");
			return;
		}
		
		NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		// Checking for errors
		if(response) {
			NSLog(@"Response from server: %@", response);
			
			// Parse the response
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			self.personData = [parser objectWithString:response];
			[self loadPersonData];
		} else {
			NSLog(@"Error! Response text is nil");
		}
	}];    
}

- (void)retrievePersonPosts {
 	// Start loading the posts
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ADNConnect userPostsUrl:self.personID]]];
	
	ServerRequest* serverConnect = [[ServerRequest alloc] init];
	[serverConnect createConnection:request usingBlock:^(NSData *responseData, NSError *error){
		if(!responseData || error) {
			NSLog(@"Error!  No response data");
			return;
		}
		
		NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		// Checking for errors
		if(response) {
			NSLog(@"Response from server: %@", response);
			
			// Parse the response
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			self.posts = [parser objectWithString:response];
			
			if([self.posts count] > 0) {
				[self.tableView reloadData];
			}
		} else {
			NSLog(@"Error! Response text is nil");
		}
	}];    
}

- (void)loadPersonData {
	NSDictionary *imageData = [self.personData objectForKey:@"avatar_image"];
	if(imageData) {
		NSString *avatarUrl = [imageData objectForKey:@"url"];
		[self pullDownPhoto:avatarUrl];
	}
	
	[self.name setText:[self.personData objectForKey:@"name"]];
	
	NSDictionary *counts = [self.personData objectForKey:@"counts"];
	if(counts) {
		NSNumber *followerNum = [counts objectForKey:@"followers"];
		NSNumber *followingNum = [counts objectForKey:@"following"]; 
		[self.followers setText:[followerNum stringValue]];
		[self.following setText:[followingNum stringValue]];		
	}
	
	NSDictionary *bio = [self.personData objectForKey:@"description"];
	if(bio) {
		[self.description setText:[bio objectForKey:@"text"]];
	}
	
	[self.view setNeedsDisplay];
}

- (void)pullDownPhoto:(NSString *)url {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
    self.photoRequest = [[ServerRequest alloc] init];
    [self.photoRequest createConnection:request usingBlock:^(NSData *responseData, NSError *error){
        if(!responseData || error) {
            NSLog(@"Error!  No response data");
            return;
        }
        
        self.userPicture = [UIImage imageWithData:responseData];
        
        // Checking for errors
        if(self.userPicture) {
            [self.avatar setImage:self.userPicture];
            [self.view setNeedsDisplay];
        } else {
            NSLog(@"Error! Picture is nil");			
        }
    }]; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section. Take out the deleted posts first.
	self.posts = [self.posts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.is_deleted != %@", [NSNumber numberWithBool:YES]]];
    return [self.posts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
    DetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSDictionary *postText = [self.posts objectAtIndex:indexPath.row];
    // If a user picture exists, pass it in
    if(self.userPicture) {
        [cell setUserPicture:self.userPicture];
    }
    
	[cell setPostData:postText];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
