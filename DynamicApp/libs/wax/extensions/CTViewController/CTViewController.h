//
//  CTViewController.h
//  CTRIP_TRAVLE
//
//  Created by new_ctrip on 13-7-2.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+popUpViewYu.h"
#import "messageBoxViewController.h"
#import "CTView.h"
#import "WXDAnimation.h"


@interface CTViewController : UIViewController

/**
 当前视图做动画
 
 @param transition 进场方式
 @param direction  进场方向
 
 @return nil 不需要返回值
 
 */
-(void)performTransition:(kSceneTransitionType)transition
           withDirection:(kSceneTransitionDirectionType)direction
          onEnteringView:(UIView *)entering
         removingOldView:(UIView *)exiting;
/**
 当前视图做动画
 
 @param transition 进场方式
 @param direction  进场方向
 @param time       动画时间
 
 @return nil 不需要返回值
 
 */
-(void)performTransition:(kSceneTransitionType)transition
           withDirection:(kSceneTransitionDirectionType)direction
          onEnteringView:(UIView *)entering
         removingOldView:(UIView *)exiting
            durationTime:(NSTimeInterval)time;

/**
 设置背景图片
 
 @param imagePath  背景图片名称
 
 @return nil 不需要返回值
 
 */
-(void)setBackgroundImage:(NSString *)imagePath;



@end