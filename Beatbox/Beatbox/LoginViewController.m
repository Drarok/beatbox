//
//  LoginViewController.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppNetConfig.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(IBAction)loginPressed:(id)sender {
	NSString *urlStr = [AppNetConfig connectUrl];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog(@"Connecting to app.net with the url: %@", urlStr);
	[[UIApplication sharedApplication] openURL:url];
}

@end
