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
#define APPNET_CLIENT_ID				@"CLIENT_ID_HERE"


/*
 Your app.net callback URL
 */
#define APPNET_CALLBACK					@"CALLBACK_HERE"


/*
 The scopes your app is requesting
 */
#define APPNET_SCOPE					@"SCOPES_HERE"


@interface AppNetConfig : NSObject
+(NSString *)connectUrl;
+(NSString *)postsUrl;
+(NSString *)globalPostsUrl;
+(NSString *)userPostsUrl:(NSString *)userID;
+(NSString *)mentionPostsUrl;
+(NSString *)userUrl:(NSString *)userID;
@end
