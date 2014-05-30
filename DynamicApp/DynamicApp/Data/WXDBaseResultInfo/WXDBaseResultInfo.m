//
//  WXDBaseResultInfo.m
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDBaseResultInfo.h"
#import "WXDStringUtility.h"

@implementation WXDResultStateInfo

-(NSInteger) state
{
    return [[WXDStringUtility toString:[dictionary valueForKey:@"status"]] integerValue];
}

-(NSString *) message
{
    return [WXDStringUtility toString:[dictionary valueForKey:@"message"]];
}

-(NSInteger) code
{
    return [[WXDStringUtility toString:[dictionary valueForKey:@"code"]] integerValue];
}

@end

@implementation WXDBaseResultInfo

-(WXDResultStateInfo *)resultState
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [dictionary valueForKey:@"status"], @"status",
                         [dictionary valueForKey:@"message"], @"message",
                         [dictionary valueForKey:@"code"], @"code",
                         nil
                        ];
    WXDResultStateInfo *result = [[WXDResultStateInfo alloc] initWithJsonObject:dic];
    return result;
}

@end
