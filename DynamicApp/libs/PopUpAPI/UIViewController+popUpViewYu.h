//
//  UIViewController+popUpViewYu.h
//  popUpViewYu
//
//  Created by HongliYu on 14-2-11.
//  Copyright (c) 2014年 HongliYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SlideBottomTop = 0,
    SlideBottomBottom,
    SlideTopBottom,
    SlideTopTop,
    SlideRightLeft,
    SlideLeftRight,
    Fade,
    Bounce,
    PushBack,
    Blur,
    Frost
}PopupViewAnimation;

@interface UIViewController (popUpViewYu)
-(void)presentPopupViewController:(UIViewController*)popupVC animationType:(PopupViewAnimation)animationType;
-(void)dismissPopupViewControllerWithanimationType:(PopupViewAnimation)animationType;

-(void)presentPopupView:(UIView *)popupView animationType:(PopupViewAnimation)animationType;
-(UIView*)getTheTopView;
@end