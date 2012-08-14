//
//  AppNetConfig.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppNetConfig.h"

@implementation AppNetConfig

+(NSString *)connectUrl {
	return [NSString stringWithFormat:@"https://alpha.app.net/oauth/authenticate?client_id=%@&response_type=token&redirect_uri=%@&scope=%@",
			APPNET_CLIENT_ID,
			APPNET_CALLBACK,
			APPNET_SCOPE];
}

+(NSString *)postsUrl {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/posts/stream?access_token=%@", accessToken];
}

+(NSString *)globalPostsUrl {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/posts/stream/global?access_token=%@", accessToken];
}

@end
