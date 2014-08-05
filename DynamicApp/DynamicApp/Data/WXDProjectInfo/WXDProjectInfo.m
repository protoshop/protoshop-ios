//
//  theListInfoCell.m
//  Protoshop
//
//  Created by HongliYu on 14-1-21.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "WXDProjectInfo.h"
#import "WXDStringUtility.h"

@implementation WXDProjectResultInfo
-(NSArray *) projectResultInfoList
{
    NSMutableArray *retList = nil;
    NSArray *resultList = [dictionary objectForKey:@"result"];
    if (resultList && [resultList isKindOfClass:[NSArray class]]) {
        if ([resultList count] != 0) retList = [[NSMutableArray alloc] initWithCapacity:0];
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WXDProjectInfo *projectInfo = [[WXDProjectInfo alloc] initWithJsonObject:obj];
            [projectInfo initWithJSONArr];
            if (projectInfo != nil) {
                [retList addObject:projectInfo];
            }
        }];
    }
    return retList;
}
@end

@implementation WXDProjectInfo
-(void)initWithJSONArr{
    self.appDesc = [WXDStringUtility toString:[dictionary objectForKey:@"appDesc"]];
    self.appID = [WXDStringUtility toString:[dictionary objectForKey:@"appID"]];
    self.appIcon = [WXDStringUtility toString:[dictionary objectForKey:@"appIcon"]];
    self.appName = [WXDStringUtility toString:[dictionary objectForKey:@"appName"]];
    self.appOwner = [WXDStringUtility toString:[dictionary objectForKey:@"appOwner"]];
    self.appOwnerNickname = [WXDStringUtility toString:[dictionary objectForKey:@"appOwnerNickname"]];
    self.appPlatform = [WXDStringUtility toString:[dictionary objectForKey:@"appPlatform"]];
    self.createTime = [WXDStringUtility toString:[dictionary objectForKey:@"createTime"]];
    self.editTime = [WXDStringUtility toString:[dictionary objectForKey:@"editTime"]];
    self.isPublic = [WXDStringUtility toString:[dictionary objectForKey:@"isPublic"]];
    self.bDownload = NO;
    self.appPath = @"";
}

-(void)debugPrint{
    DLog(@"debugPrint begins \n appDesc:%@,appID:%@,appIcon:%@,appName:%@,appOwner:%@,appOwnerNickname:%@,appPlatform:%@,createTime:%@,editTime:%@,isPublic:%@,hasDL:%i \n debugPrint ends",self.appDesc,self.appID,self.appIcon,self.appName,self.appOwner,self.appOwnerNickname,self.appPlatform,self.createTime,self.editTime,self.isPublic,self.bDownload);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.appDesc forKey:@"appDesc"];
    [aCoder encodeObject:self.appID forKey:@"appID"];
    [aCoder encodeObject:self.appIcon forKey:@"appIcon"];
    [aCoder encodeObject:self.appName forKey:@"appName"];
    [aCoder encodeObject:self.appOwner forKey:@"appOwner"];
    [aCoder encodeObject:self.appOwnerNickname forKey:@"appOwnerNickname"];
    [aCoder encodeObject:self.appPlatform forKey:@"appPlatform"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.editTime forKey:@"editTime"];
    [aCoder encodeObject:self.isPublic forKey:@"isPublic"];
    [aCoder encodeBool:self.bDownload forKey:@"bDownload"];
    [aCoder encodeObject:self.appPath forKey:@"appPath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.appDesc = [aDecoder decodeObjectForKey:@"appDesc"];
        self.appID = [aDecoder decodeObjectForKey:@"appID"];
        self.appIcon = [aDecoder decodeObjectForKey:@"appIcon"];
        self.appName = [aDecoder decodeObjectForKey:@"appName"];
        self.appOwner = [aDecoder decodeObjectForKey:@"appOwner"];
        self.appOwnerNickname = [aDecoder decodeObjectForKey:@"appOwnerNickname"];
        self.appPlatform = [aDecoder decodeObjectForKey:@"appPlatform"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.editTime = [aDecoder decodeObjectForKey:@"editTime"];
        self.isPublic = [aDecoder decodeObjectForKey:@"isPublic"];
        self.bDownload = [aDecoder decodeBoolForKey:@"bDownload"];
        self.appPath = [aDecoder decodeObjectForKey:@"appPath"];
    }
    return self;
}

-(id) copyWithZone:(NSZone *)zone
{
    WXDProjectInfo* copy = [[[self class] alloc] init];
    if (copy) {
        copy.appDesc = [self.appDesc copy];
        copy.appID = [self.appID copy];
        copy.appIcon = [self.appIcon copy];
        copy.appName = [self.appName copy];
        copy.appOwner = [self.appOwner copy];
        copy.appOwnerNickname = [self.appOwnerNickname copy];
        copy.appPlatform = [self.appPlatform copy];
        copy.createTime = [self.createTime copy];
        copy.editTime = [self.editTime copy];
        copy.isPublic = [self.isPublic copy];
        copy.bDownload = self.bDownload;
        copy.appPath = [self.appPath copy];
    }
    return copy;
}
@end