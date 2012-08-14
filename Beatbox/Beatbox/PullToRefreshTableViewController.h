//
//  PullToRefreshTableViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefreshTableViewController : UITableViewController
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)showErrorAndClose;
@end
