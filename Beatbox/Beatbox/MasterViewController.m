//
//  MasterViewController.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailTableViewController.h"
#import "AppNetConfig.h"

@interface MasterViewController ()
@property(strong, nonatomic) NSArray *menu;
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController, loginViewController, menu;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		self.menu = [NSArray arrayWithObjects:@"My Stream", @"My Posts", @"Mentions", @"Global", nil];
    }
    return self;
}

- (void)awakeFromNib {
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPost:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.detailViewController = (DetailTableViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	// Check to see if the user needs to login
	[self _performLoginIfRequired];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)_performLoginIfRequired {	
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	if(!accessToken) {
		NSLog(@"Login Required");
		UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
		self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
		[self presentModalViewController:self.loginViewController animated:YES];
	}
}

- (void)addNewPost:(id)sender {

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	NSDate *object = [self.menu objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *selection = [self.menu objectAtIndex:indexPath.row];
	if([selection isEqualToString:@"My Stream"]) {
		[self.detailViewController setUrlToLoad:[AppNetConfig postsUrl]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"My Posts"]) {
		[self.detailViewController setUrlToLoad:[AppNetConfig userPostsUrl:@"me"]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"Mentions"]) {
		[self.detailViewController setUrlToLoad:[AppNetConfig mentionPostsUrl]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"Global"]) {
		[self.detailViewController setUrlToLoad:[AppNetConfig globalPostsUrl]];
		[self.detailViewController startLoading];
	}
}

@end
