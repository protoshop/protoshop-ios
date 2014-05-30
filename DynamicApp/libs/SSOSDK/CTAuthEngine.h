//
//  CTAuthEngine.h
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSSOAuthDelegate.h"
#import "authconfig.h"

@interface CTAuthEngine : NSObject

+(void)startSSOAuth:(id<CTSSOAuthDelegate>)delegate;
+(void)startSSOAuth:(id<CTSSOAuthDelegate>)delegate withType:(eAuthType)type;

+(BOOL)logout;

@end
