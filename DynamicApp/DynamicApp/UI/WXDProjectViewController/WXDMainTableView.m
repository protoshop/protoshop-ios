//
//  WXDMainTableView.m
//  Protoshop
//
//  Created by HongliYu on 14-5-16.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 列表容器
//  归属人：虞鸿礼
//  修改时间：2014年5月16日

#import "WXDMainTableView.h"

@implementation WXDMainTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<WXDMainTableViewDelegate>)aMTVDelegateDelegate{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.MTVDelegate = aMTVDelegateDelegate;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
        self.headerView = [[WXDMTVLoadingView alloc] initWithFrame:rect atTop:YES];
        self.headerView.atTop = YES;
        
        [self addSubview:self.headerView];
        
        rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        [self sendSubviewToBack:self.headerView];//这个是把某个view移动到subviews的stack的索引为0的位置
    }
    return self;
}

/**
 *  从ib初始化以后，参数需要设置
 *
 *  @param frame WXDMTVLoadingView frame
 *  @param style UITableViewStyle
 */
- (void)setInitParamsWith:(CGRect)frame style:(UITableViewStyle)style{
    CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
    self.headerView = [[WXDMTVLoadingView alloc] initWithFrame:rect atTop:YES];
    self.headerView.atTop = YES;
    [self addSubview:self.headerView];
    rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    [self sendSubviewToBack:self.headerView];
}


#pragma mark - Scroll methods
- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    if (self.headerView.state == MTVStateLoading) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < - MTVOffsetY) {//header totally appeard
        self.headerView.state = MTVStatePulling;
    } else if (offset.y > -MTVOffsetY && offset.y < 0){//header part appeared
        self.headerView.state = MTVStateNormal;
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView {
    if (self.headerView.state == MTVStateLoading) {
        return;
    }
    if (self.headerView.state == MTVStatePulling) {
        self.headerView.state = MTVStateLoading;
        [UIView animateWithDuration:MTVAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(MTVOffsetY, 0, 0, 0);
        }];
        if (self.MTVDelegate && [self.MTVDelegate respondsToSelector:@selector(WXDMainTableViewDidStartRefreshing:)]) {
            [self.MTVDelegate WXDMainTableViewDidStartRefreshing:self];
        }
    }
}

- (void)tableViewDidFinishedLoading {
    [self tableViewDidFinishedLoadingWithMessage:@"刷新完毕"];
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg{
    if (self.headerView.loading) {
        self.headerView.loading = NO;
        [self.headerView setState:MTVStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (self.MTVDelegate && [self.MTVDelegate respondsToSelector:@selector(WXDMainTableViewRefreshingFinishedDate)]) {
            date = [self.MTVDelegate WXDMainTableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:MTVAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
}

- (void)flashMessage:(NSString *)msg{
    __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = rect;
        SET_FONT(_msgLabel,@"FontAwesome",16.0f);
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1.0];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];
    }
    [self setUserInteractionEnabled:NO];
    _msgLabel.text = msg;
    rect.origin.y += 20;
    [UIView animateWithDuration:0.4f animations:^{
        _msgLabel.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            [_msgLabel removeFromSuperview];
            _msgLabel = nil;
            [self setUserInteractionEnabled:YES];
        }];
    }];
}

@end
