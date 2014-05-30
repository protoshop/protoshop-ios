//
//  WXDBaseResultInfo.h
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDBaseInfo.h"

@interface WXDResultStateInfo : WXDBaseInfo
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger code;
@end

@interface WXDBaseResultInfo : WXDBaseInfo
@property (nonatomic, strong) WXDResultStateInfo *resultState;
@end
