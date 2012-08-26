//
//  PersonViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController
@property(strong, nonatomic) NSString *personID;
@property (strong, nonatomic) UIImage *userPicture;

@property(strong, nonatomic) IBOutlet UIImageView *avatar;
@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet UIButton *followers;
@property(strong, nonatomic) IBOutlet UIButton *following;
@property(strong, nonatomic) IBOutlet UITextView *description;

- (IBAction)clickedFollowersBtn:(id)sender;
- (IBAction)clickedFollowingBtn:(id)sender;

@end
