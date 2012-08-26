//
//  PersonFollowersViewController.m
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonFollowersViewController.h"
#import "ServerRequest.h"
#import "ADNConnect.h"
#import "SBJson.h"

@interface PersonFollowersViewController ()
@property (strong, nonatomic) NSArray *followersList;
@property(strong, nonatomic) UITableView *tableView;
@end

@implementation PersonFollowersViewController

@synthesize followersList, tableView, showFollowing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showFollowing = NO;
        self.followersList = [NSArray array];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.showFollowing) {
        self.title = @"Following";
    } else {
        self.title = @"Followers";
    }
    
    [self retrievePersonFollowers];
    
    NSInteger startY = self.avatar.frame.origin.y + self.avatar.frame.size.height + 10;
    [self.tableView setFrame:CGRectMake(20, startY, self.view.frame.size.width - 40, self.view.frame.size.height - startY)];
    [self.view addSubview:tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)retrievePersonFollowers {
 	// Start loading the posts
	NSMutableURLRequest *request = nil;
    if(self.showFollowing) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ADNConnect userFollowingUrl:self.personID]]];
    } else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ADNConnect userFollowersUrl:self.personID]]];        
    }
	
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
			self.followersList = [parser objectWithString:response];
			
			if([self.followersList count] > 0) {
				[self.tableView reloadData];
			}
		} else {
			NSLog(@"Error! Response text is nil");
		}
	}];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.followersList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSDictionary *userText = [self.followersList objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[userText objectForKey:@"name"]];
    
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
