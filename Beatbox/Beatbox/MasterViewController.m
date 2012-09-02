//
//  MasterViewController.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailTableViewController.h"
#import "ADNConnect.h"

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

	self.detailViewController = (DetailTableViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	// Configure table
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wood-6.png"]]];
	
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"MasterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSString *object = [self.menu objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
	[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
	[[cell textLabel] setTextColor:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *selection = [self.menu objectAtIndex:indexPath.row];
	if([selection isEqualToString:@"My Stream"]) {
		[self.detailViewController setUrlToLoad:[ADNConnect postsUrl]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"My Posts"]) {
		[self.detailViewController setUrlToLoad:[ADNConnect userPostsUrl:@"me"]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"Mentions"]) {
		[self.detailViewController setUrlToLoad:[ADNConnect mentionPostsUrl]];
		[self.detailViewController startLoading];
	} else if([selection isEqualToString:@"Global"]) {
		[self.detailViewController setUrlToLoad:[ADNConnect globalPostsUrl]];
		[self.detailViewController startLoading];
	}
}

@end
