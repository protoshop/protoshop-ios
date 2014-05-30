//
//  WXDMainTableView.h
//  Protoshop
//
//  Created by HongliYu on 14-5-16.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 列表容器
//  归属人：虞鸿礼
//  修改时间：2014年5月16日

#import <UIKit/UIKit.h>
#import "WXDMTVLoadingView.h"

@protocol WXDMainTableViewDelegate;

@interface WXDMainTableView : UITableView<UIScrollViewDelegate>
@property (nonatomic,strong) WXDMTVLoadingView *headerView;
@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,assign) BOOL *loading;
@property (assign,nonatomic) id <WXDMainTableViewDelegate> MTVDelegate;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<WXDMainTableViewDelegate>)aMTVDelegateDelegate;
- (void)setInitParamsWith:(CGRect)frame style:(UITableViewStyle)style;
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedLoading;
- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;
@end

@protocol WXDMainTableViewDelegate <NSObject>
@required
- (void)WXDMainTableViewDidStartRefreshing:(WXDMainTableView *)tableView;
@optional
- (NSDate *)WXDMainTableViewRefreshingFinishedDate;
@end