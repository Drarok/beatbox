//
//  SingleTweetViewController.h
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFTweetLabel.h"

@interface SinglePostViewController : UIViewController
@property(strong, nonatomic) NSDictionary *postData;
@property(nonatomic, strong) UIImage *userPicture;

@property(strong, nonatomic) IBOutlet UIImageView *userImage;
@property(strong, nonatomic) IBOutlet UILabel *userName;
@property(strong, nonatomic) IBOutlet UILabel *postDate;
@property(strong, nonatomic) IBOutlet UILabel *followers;
@property(strong, nonatomic) IBOutlet UILabel *following;
@property(strong, nonatomic) IBOutlet UITextView *description;
@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end
