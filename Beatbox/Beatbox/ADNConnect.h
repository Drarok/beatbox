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
+(NSString *)mentionPostsUrl;
+(NSString *)userUrl:(NSString *)userID;
@end
