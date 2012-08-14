//
//  DetailTableViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableViewController.h"

@interface DetailTableViewController : PullToRefreshTableViewController<UISplitViewControllerDelegate>
@property (strong, nonatomic) NSString *urlToLoad;
@end
