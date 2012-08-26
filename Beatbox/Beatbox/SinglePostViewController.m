//
//  SingleTweetViewController.m
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinglePostViewController.h"
#import "ServerRequest.h"
#import "ADNConnect.h"
#import "SBJson.h"

static NSDateFormatter *preDateFormatter = nil;
static NSDateFormatter *postDateFormatter = nil;

@interface SinglePostViewController ()
@property(strong, nonatomic) IFTweetLabel *userPost;
@property(strong, nonatomic) UILabel *postDate;
@end

@implementation SinglePostViewController

@synthesize postData = postData_, userPost, postDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userPost = [[IFTweetLabel alloc] initWithFrame:CGRectZero];
        self.postDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.postDate setFont:[UIFont systemFontOfSize:14.0]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSInteger startY = self.avatar.frame.origin.y + self.avatar.frame.size.height + 10;
    [self.postDate setFrame:CGRectMake(20, startY, self.view.frame.size.width - 40, 20)];
    [self.view addSubview:self.postDate];
    
    startY = self.postDate.frame.origin.y + self.postDate.frame.size.height;
    [self.userPost setFrame:CGRectMake(20, startY, self.view.frame.size.width - 40, 90)];
    [self.userPost setBackgroundColor:[UIColor clearColor]];
    [self.userPost setNumberOfLines:0];
    [self.userPost setLinksEnabled:YES];
    [self.view addSubview:self.userPost];
    
    if(self.postData) {
        [self _setupPostData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)setPostData:(NSDictionary *)postData {
    postData_ = postData;
    
    // Grab the userID and set it in the post
    NSDictionary *user = [postData objectForKey:@"user"];
    NSString *userID = [user objectForKey:@"id"];
    [self setPersonID:userID];
}

- (void)_setupPostData {
	NSString *created = [self.postData objectForKey:@"created_at"];
	NSString *text = [self.postData objectForKey:@"text"];
	
	if(!preDateFormatter) {
		preDateFormatter = [[NSDateFormatter alloc] init];
		[preDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
		[preDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	// Convert the date object to a user-visible date string.
	NSDate *date = [preDateFormatter dateFromString:created];
	
	if(!postDateFormatter) {
		postDateFormatter = [[NSDateFormatter alloc] init];
		[postDateFormatter setDateStyle:NSDateFormatterShortStyle];
		[postDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	[self.postDate setText:[postDateFormatter stringFromDate:date]];
	
	if(text) {
		[self.userPost setText:text];
	}
}

@end
