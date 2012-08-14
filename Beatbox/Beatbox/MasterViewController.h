//
//  MasterViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class DetailTableViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailTableViewController *detailViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@end
