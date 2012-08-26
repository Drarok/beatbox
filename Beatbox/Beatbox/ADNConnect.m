//
//  AppNetConfig.m
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADNConnect.h"

const NSString *adnUrl = @"https://alpha-api.app.net";

@implementation ADNConnect

+(NSString *)connectUrl {
	return [NSString stringWithFormat:@"https://alpha.app.net/oauth/authenticate?client_id=%@&response_type=token&redirect_uri=%@&scope=%@",
			APPNET_CLIENT_ID,
			APPNET_CALLBACK,
			APPNET_SCOPE];
}

+(NSString *)postsUrl {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/posts/stream?access_token=%@", adnUrl, accessToken];
}

+(NSString *)globalPostsUrl {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/posts/stream/global?access_token=%@", adnUrl, accessToken];
}

+(NSString *)userPostsUrl:(NSString *)userID {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/users/%@/posts?access_token=%@", adnUrl, userID, accessToken];
}

+(NSString *)mentionPostsUrl {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/users/me/mentions?access_token=%@", adnUrl, accessToken];
}

+(NSString *)userUrl:(NSString *)userID {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/users/%@?access_token=%@", adnUrl, userID, accessToken];
}

+(NSString *)taggedPostsUrl:(NSString *)tag {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/posts/tag/%@?access_token=%@", adnUrl, tag, accessToken];    
}

+(NSString *)userFollowersUrl:(NSString *)userID {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/users/%@/followers?access_token=%@", adnUrl, userID, accessToken];    
}

+(NSString *)userFollowingUrl:(NSString *)userID {
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
	return [NSString stringWithFormat:@"%@/stream/0/users/%@/following?access_token=%@", adnUrl, userID, accessToken];    
}

@end
