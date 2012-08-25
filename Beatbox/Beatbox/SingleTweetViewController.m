//
//  SingleTweetViewController.m
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleTweetViewController.h"
#import "ServerRequest.h"

static NSDateFormatter *preDateFormatter = nil;
static NSDateFormatter *postDateFormatter = nil;

@interface SingleTweetViewController ()
@property(strong, nonatomic) IFTweetLabel *userPost;
@property(strong, nonatomic) NSTimer *photoTimer;
@property(strong, nonatomic) ServerRequest *photoRequest;
@end

@implementation SingleTweetViewController

@synthesize postData;
@synthesize userImage, userName, userPost, postDate, photoTimer, photoRequest, userPicture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userPost = [[IFTweetLabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)dealloc {
    if(self.photoTimer) {
        [self.photoTimer invalidate];
    }
    self.photoTimer = nil;
    
    if(self.photoRequest) {
        [self.photoRequest cancelRequest];
    }
    self.photoRequest = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSInteger startY = self.postDate.frame.origin.y+self.postDate.frame.size.height;
    [self.userPost setFrame:CGRectMake(20, startY, self.view.frame.size.width - 40, 90)];
    [self.userPost setBackgroundColor:[UIColor clearColor]];
    [self.userPost setNumberOfLines:0];
    [self.userPost setLinksEnabled:YES];
    [self.view addSubview:self.userPost];
    
    if(self.postData) {
        [self _setupTweetData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)_setupTweetData {
	NSString *created = [postData objectForKey:@"created_at"];
	NSDictionary *user = [postData objectForKey:@"user"];
	NSDictionary *avatar = [user objectForKey:@"avatar_image"];
	NSString *avatarUrl = [avatar objectForKey:@"url"];
	NSString *name = [user objectForKey:@"username"];	
	NSString *text = [postData objectForKey:@"text"];
	
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
	
	if(name) {
		[self.userName setText:name];
	}
	
	if(text) {
		[self.userPost setText:text];
	}
	
    if(self.userPicture) {
        [self.userImage setImage:self.userPicture];
    } else if(avatarUrl) {
		// Set the default avatar first
		[self.userImage setImage:[UIImage imageNamed:@"default_avatar"]];
        
        // Set a timer to fire in 0.5 seconds -- allows you to scroll a list of people and not have your device constantly pulling down photos
        self.photoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_timerFired:) userInfo:nil repeats:NO];
	}
}

- (void)_timerFired:(NSTimer *)timer {
    // Try to pull down the profile photo
	NSDictionary *user = [self.postData objectForKey:@"user"];
	NSDictionary *avatar = [user objectForKey:@"avatar_image"];
	NSString *avatarUrl = [avatar objectForKey:@"url"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:avatarUrl]];
	
    self.photoRequest = [[ServerRequest alloc] init];
    [self.photoRequest createConnection:request usingBlock:^(NSData *responseData, NSError *error){
        if(!responseData || error) {
            NSLog(@"Error!  No response data");
            return;
        }
        
        UIImage *picture = [UIImage imageWithData:responseData];
        
        // Checking for errors
        if(picture) {
            [self.userImage setImage:picture];
            //[self.view setNeedsDisplay];
        } else {
            NSLog(@"Error! Picture is nil");			
        }
    }]; 
}


@end
