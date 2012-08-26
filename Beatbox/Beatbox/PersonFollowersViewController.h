//
//  PersonFollowersViewController.h
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonViewController.h"

@interface PersonFollowersViewController : PersonViewController<UITableViewDelegate, UITableViewDataSource>
@property(assign, nonatomic) BOOL showFollowing;
@end
