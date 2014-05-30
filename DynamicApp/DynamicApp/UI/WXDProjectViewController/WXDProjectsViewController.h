//
//  ViewController.h
//  DynamicApp
//
//  Created by new_ctrip on 13-6-13.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//
//  Protoshop 主页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import <UIKit/UIKit.h>
#import "WXDAppDelegate.h"
#import "WXDMainTableView.h"
#import "WXDRequestCommand.h"

/** App的主控制器*/
@interface WXDProjectsViewController : WXDBaseViewController
/** 清理缓存需要刷新*/
@property (assign,nonatomic) BOOL clearCacheNeedRefresh;
/** 判断是否处于正在刷新的状态*/
@property (nonatomic) BOOL refreshing;
@end