//
//  SingleTweetViewController.h
//  Beatbox
//
//  Created by Ryan on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFTweetLabel.h"
#import "PersonViewController.h"

@interface SinglePostViewController : PersonViewController
@property(strong, nonatomic) NSDictionary *postData;
@end
