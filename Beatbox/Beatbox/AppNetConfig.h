//
//  AppNetConfig.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Place your App.net client id here
 */
#define APPNET_CLIENT_ID				@"BBTb7ee2csL7BUQFhc36k8RDuMqrH6Kj"


/*
 Your app.net callback URL
 */
#define APPNET_CALLBACK					@"beatbox://callback/"


/*
 The scopes your app is requesting
 */
#define APPNET_SCOPE					@"stream,email,write_post,follow,messages"


@interface AppNetConfig : NSObject
+(NSString *)connectUrl;
+(NSString *)postsUrl;
+(NSString *)globalPostsUrl;
@end
