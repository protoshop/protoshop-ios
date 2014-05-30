//
//  WXDStringUtility.h
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDStringUtility : NSObject
+ (NSString *)toString:(id) object;
+ (NSString *)trim:(NSString *)string;
+ (NSString *)md5:(NSString *)string;
+ (BOOL) verifyEmail:(NSString *)string;
+ (NSString *)versin;
@end
