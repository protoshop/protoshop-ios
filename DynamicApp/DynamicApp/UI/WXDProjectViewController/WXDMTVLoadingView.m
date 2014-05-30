//
//  WXDMTVLoadingView.m
//  Protoshop
//
//  Created by HongliYu on 14-5-16.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 列表刷新下拉容器
//  归属人：虞鸿礼
//  修改时间：2014年5月16日

#import "WXDMTVLoadingView.h"

@interface WXDMTVLoadingView()
- (void)updateRefreshDate :(NSDate *)date;
- (void)layouts;
@end

@implementation WXDMTVLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//Default is at top
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top {
    self = [super initWithFrame:frame];
    if (self) {
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        SET_FONT(_stateLabel,@"FontAwesome",15.0f);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.text = @"下拉可以刷新";
        [self addSubview:_stateLabel];
        
        _dateLabel = [[UILabel alloc]init];
        SET_FONT(_dateLabel,@"FontAwesome",12.0f);
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //        _dateLabel.text = NSLocalizedString(@"最后更新", @"");
        [self addSubview:_dateLabel];
                
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        [self layouts];
    }
    return self;
}

- (void)layouts {
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame;
    float y,margin;
    margin = (MTVOffsetY - 2*MTVLabelHeight)/2;
    if (self.isAtTop) {
        y = size.height - margin - MTVLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,MTVLabelHeight);
        
        y = y - MTVLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, MTVLabelHeight);
        
    } else {    //at bottom
        y = margin + 10;
        stateFrame = CGRectMake(0, y, size.width, MTVLabelHeight );
        
        y = y + MTVLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, MTVLabelHeight);
        
        _stateLabel.text = NSLocalizedString(@"上拉可以加载", @"");
    }
    self.stateLabel.frame = stateFrame;
    self.dateLabel.frame = dateFrame;
    self.activityView.center = CGPointMake(size.width - 30, size.height - margin - MTVLabelHeight);
}

- (void)setState:(MTVState)state {
    [self setState:state animated:YES];
}

- (void)setState:(MTVState)state animated:(BOOL)animated{
    if (self.state != state) {
        _state = state;//不能改为self.state不然会调用上面的set方法，出现死循环
        if (self.state == MTVStateLoading) {    //Loading
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            self.loading = YES;
            if (self.isAtTop) {
                self.stateLabel.text = NSLocalizedString(@"正在努力刷新", @"");
            } else {
                self.stateLabel.text = NSLocalizedString(@"正在加载", @"");
            }
            
        } else if (self.state == MTVStatePulling && !self.loading) {    //Scrolling
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            
            if (self.isAtTop) {
                self.stateLabel.text = NSLocalizedString(@"松开即可刷新", @"");
            } else {
                self.stateLabel.text = NSLocalizedString(@"释放加载更多", @"");
            }
            
        } else if (self.state == MTVStateNormal && !self.loading){    //Reset
            
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            
            if (self.isAtTop) {
                self.stateLabel.text = NSLocalizedString(@"下拉可以刷新", @"");
            } else {
                self.stateLabel.text = NSLocalizedString(@"上拉加载更多", @"");
            }
        }
    }
}

- (void)updateRefreshDate :(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
}

@end
