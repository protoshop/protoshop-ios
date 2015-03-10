//
//  WXDBaseViewController.h
//  Protoshop
//
//  Created by kuolei on 3/20/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//
//  Protoshop 基类控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import <UIKit/UIKit.h>

@interface WXDBaseViewController : UIViewController
{
@protected
    BOOL bReachability;
}
-(id) initWithNavTitle:(NSString*)title;
-(void) setBaseNavigationWithTitle:(NSString *)title;
-(void) initParams;
-(void) dismissHUD;
-(void) showHUD;
-(void) showHUDWithMessage:(NSString *)message;

@property (strong, nonatomic) UILabel *navLabel;
@property (strong, nonatomic) UINavigationController *WXDNavVC;

@end
