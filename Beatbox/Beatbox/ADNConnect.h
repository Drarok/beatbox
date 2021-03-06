//
//  AppNetConfig.h
//  Beatbox
//
//  Created by Ryan Gerard on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNConfig.h"

@interface ADNConnect : NSObject
+(NSString *)connectUrl;
+(NSString *)postsUrl;
+(NSString *)globalPostsUrl;
+(NSString *)userPostsUrl:(NSString *)userID;
+(NSString *)userFollowersUrl:(NSString *)userID;
+(NSString *)userFollowingUrl:(NSString *)userID;
+(NSString *)mentionPostsUrl;
+(NSString *)userUrl:(NSString *)userID;
+(NSString *)taggedPostsUrl:(NSString *)tag;
@end
