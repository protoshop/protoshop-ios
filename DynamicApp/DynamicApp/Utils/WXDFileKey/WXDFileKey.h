//
//  GLFileKey.h
//  ToHell2iOS
//
//  Created by HongliYu on 13-12-12.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDFileKey : NSObject<NSCoding>
/**
 *  文件夹的名字
 */
@property (nonatomic, retain) NSString *keyName;
/**
 *  包含文件夹名字的完整路径
 */
@property (nonatomic, retain) NSString *filePath;
@end