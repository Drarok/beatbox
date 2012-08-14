//
//  LoginViewController.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;

-(IBAction)loginPressed:(id)sender;
@end
