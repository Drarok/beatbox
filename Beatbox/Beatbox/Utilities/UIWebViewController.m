//
//  UIWebViewController.m
//  Beatbox
//
//  Created by Ryan on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()

@end

@implementation UIWebViewController

@synthesize webView, urlToLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.webView setDelegate:self];
    [self.webView setScalesPageToFit:YES];
    [self.view addSubview:self.webView];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]];
    [self.webView loadRequest:requestObj];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished loading");
    
    NSString *docTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setTitle:docTitle];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error %@", error);
     [self setTitle:@"Error Loading"];
}

@end
