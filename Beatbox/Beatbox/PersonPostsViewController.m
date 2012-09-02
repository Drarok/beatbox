//
//  PersonPostsViewController.m
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonPostsViewController.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "DetailTableViewCell.h"
#import "ADNConnect.h"

@interface PersonPostsViewController ()
@property (strong, nonatomic) NSArray *posts;
@property(strong, nonatomic) UITableView *tableView;
@end

@implementation PersonPostsViewController

@synthesize posts, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.posts = [NSArray array];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrievePersonPosts];
    
	// Configure table
	[self.tableView setSeparatorColor:[UIColor blackColor]];
	[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hexabump.png"]]];
	
    NSInteger startY = self.avatar.frame.origin.y + self.avatar.frame.size.height + 10;
    [self.tableView setFrame:CGRectMake(20, startY, self.view.frame.size.width - 40, self.view.frame.size.height - startY)];
    [self.view addSubview:tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
