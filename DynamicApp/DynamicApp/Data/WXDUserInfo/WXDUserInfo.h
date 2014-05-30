//
//  WXDUserInfo.h
//  Protoshop
//
//  Created by kuolei on 3/14/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDBaseInfo.h"
#import "WXDBaseResultInfo.h"

@interface WXDUserResultInfo : WXDBaseResultInfo
@property (nonatomic, strong, readonly) NSArray *userResultInfoList;
@end

@interface WXDUserInfo : WXDBaseInfo
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *nickname;
@property (nonatomic, strong, readonly) NSString *token;

@end
