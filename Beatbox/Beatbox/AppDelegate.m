//
//  AppDelegate.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MasterViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Hookup the delegate
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"beatbox"]) {
		NSString *accessTokenParam = [url fragment];
		
		// The fragment comes in looking like "access_token=XXXX"
		NSArray *accessParts = [accessTokenParam componentsSeparatedByString:@"="];
		if([accessParts count] > 1) {
			NSString *accessToken = [accessParts objectAtIndex:1];
			NSLog(@"Access Token: %@", accessToken);
			
			// Save off the access token
			[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			// Find the login view
			UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
			UINavigationController *navController = [splitController.viewControllers objectAtIndex:0];
			MasterViewController *masterController = [[navController viewControllers] objectAtIndex:0];
			LoginViewController *loginController = [masterController loginViewController];

			// Dismiss the login view
			[loginController dismissModalViewControllerAnimated:YES];
		}
		return YES;
	}
	
	return NO;
}

@end
