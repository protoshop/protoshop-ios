//
//  theListInfoCell.h
//  Protoshop
//
//  Created by HongliYu on 14-1-21.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "WXDBaseInfo.h"
#import "WXDBaseResultInfo.h"

@interface WXDProjectResultInfo : WXDBaseResultInfo
@property (nonatomic, strong, readonly) NSArray *projectResultInfoList;
@end

@interface WXDProjectInfo : WXDBaseInfo<NSCoding>
@property (nonatomic,strong) NSString *appDesc;
@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *appIcon;
@property (nonatomic,strong) NSString *appName;
@property (nonatomic,strong) NSString *appOwner;
@property (nonatomic,strong) NSString *appOwnerNickname;
@property (nonatomic,strong) NSString *appPlatform;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *editTime;
@property (nonatomic,strong) NSString *isPublic;

@property (nonatomic,assign) BOOL hasDL;
-(void)initWithJSONArr;
-(void)debugPrint;
@end