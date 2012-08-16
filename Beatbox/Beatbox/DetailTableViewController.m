//
//  DetailTableViewController.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailTableViewController.h"
#import "ServerRequest.h"
#import "AppNetConfig.h"
#import "SBJson.h"
#import "DetailTableViewCell.h"
#import "IFTweetLabel.h"
#import "PersonViewController.h"

@interface DetailTableViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSArray *posts;
@end

@implementation DetailTableViewController

@synthesize masterPopoverController = _masterPopoverController, posts, urlToLoad;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
		self.posts = [NSArray array];
		self.urlToLoad = [AppNetConfig postsUrl];
		
		[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"accessToken" options:NSKeyValueObservingOptionNew context:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		self.posts = [NSArray array];
		self.urlToLoad = [AppNetConfig postsUrl];
		
		[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"accessToken" options:NSKeyValueObservingOptionNew context:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];
    }
    return self;
}

- (void)dealloc {
	[[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"accessToken"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self startLoading];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"accessToken"]) {
		self.urlToLoad = [AppNetConfig postsUrl];
		[self startLoading];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSDictionary *postText = [self.posts objectAtIndex:indexPath.row];
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

- (void)refresh {
 	// Start loading the posts
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]];
	
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
			[self stopLoading];
			
			// Parse the response
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			self.posts = [parser objectWithString:response];
			
			if([self.posts count] > 0) {
				[self.tableView reloadData];
			}
		} else {
			NSLog(@"Error! Response text is nil");
			[self showErrorAndClose];
		}
	}];    
}

- (void)_handleTweetNotification:(NSNotification *)notification {
	NSLog(@"handleTweetNotification: notification = %@", notification);
	
	NSString *match = [notification object];
	NSLog(@"Navigating to %@", match);
	
	// Check to see if the string refers to a person, subject, or URL
	if([match characterAtIndex:0] == '@' && [match length] > 1) {
		
		NSString *personID = [self findUserIDFromMatch:[match substringFromIndex:1]];
		if(personID) {
			PersonViewController *person = [[PersonViewController alloc] initWithNibName:nil bundle:nil];
			[person setTitle:match];
			[person setPersonID:personID];
			[self.navigationController pushViewController:person animated:YES];	
		} else {
			NSLog(@"Could not find person ID!");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, the person you selected could not be found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	} else if([match characterAtIndex:0] == '#') {
		
		NSLog(@"Hash!");
	}
}

- (NSString *)findUserIDFromMatch:(NSString *)name {
	NSString *foundID = nil;
	
	for(NSDictionary *post in self.posts) {
		NSDictionary *entities = [post objectForKey:@"entities"];
		
		if(entities) {
			NSArray *mentions = [entities objectForKey:@"mentions"];
		
			if(mentions) {				
				for(NSDictionary *singleMention in mentions) {
					
					if([[singleMention objectForKey:@"name"] caseInsensitiveCompare:name] == NSOrderedSame) {
						foundID = [singleMention objectForKey:@"id"];
						break;
					}
				}
			}
		}
	}
	
	return foundID;
}

@end
