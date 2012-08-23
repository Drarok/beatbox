//
//  PersonViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSString *personID;

@property(strong, nonatomic) IBOutlet UIImageView *avatar;
@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet UILabel *followers;
@property(strong, nonatomic) IBOutlet UILabel *following;
@property(strong, nonatomic) IBOutlet UITextView *description;
@property(strong, nonatomic) IBOutlet UITableView *tableView;
@end
