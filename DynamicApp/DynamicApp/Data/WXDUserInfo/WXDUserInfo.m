//
//  WXDUserInfo.m
//  Protoshop
//
//  Created by kuolei on 3/14/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDUserInfo.h"
#import "WXDStringUtility.h"

@implementation WXDUserResultInfo
-(NSArray *) userResultInfoList
{
    NSMutableArray *retList = nil;
    NSArray *resultList = [dictionary objectForKey:@"result"];
    if (resultList && [resultList isKindOfClass:[NSArray class]]) {
        if ([resultList count] != 0) retList = [[NSMutableArray alloc] initWithCapacity:0];
        
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WXDUserInfo *userInfo = [[WXDUserInfo alloc] initWithJsonObject:obj];
            if (userInfo != nil) {
                [retList addObject:userInfo];
            }
        }];
    }
    
    return retList;
}
@end

@implementation WXDUserInfo
-(NSString *) name
{
    return [WXDStringUtility toString:[dictionary objectForKey:@"name"]];
}

-(NSString *) email
{
    return [WXDStringUtility toString:[dictionary objectForKey:@"email"]];
}

-(NSString *) nickname
{
    return [WXDStringUtility toString:[dictionary objectForKey:@"nickname"]];
}

-(NSString *) token
{
    return [WXDStringUtility toString:[dictionary objectForKey:@"token"]];
}

@end
