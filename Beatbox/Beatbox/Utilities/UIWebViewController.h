//
//  UIWebViewController.h
//  Beatbox
//
//  Created by Ryan on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewController : UIViewController<UIWebViewDelegate>
@property(strong, nonatomic) NSString *urlToLoad;
@property(strong, nonatomic) IBOutlet UIWebView *webView;
@end
