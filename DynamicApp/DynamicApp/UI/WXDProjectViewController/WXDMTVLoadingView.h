//
//  WXDMTVLoadingView.h
//  Protoshop
//
//  Created by HongliYu on 14-5-16.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 列表刷新下拉容器
//  归属人：虞鸿礼
//  修改时间：2014年5月16日

#import <UIKit/UIKit.h>
#import "WXDConst.h"

#define MTVOffsetY 60.f
#define MTVMargin 5.f
#define MTVLabelHeight 20.f
#define MTVLabelWidth 100.f
#define MTVAnimationDuration .18f

typedef NS_ENUM(NSUInteger, MTVState){
    MTVStateNormal = 0,
    MTVStatePulling = 1,
    MTVStateLoading = 2,
};

@interface WXDMTVLoadingView : UIView
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) MTVState state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;
- (void)updateRefreshDate:(NSDate *)date;
- (void)setState:(MTVState)state animated:(BOOL)animated;
@end
