//
//  UIViewController+popUpViewYu.m
//  popUpViewYu
//
//  Created by HongliYu on 14-2-11.
//  Copyright (c) 2014年 HongliYu. All rights reserved.
//

#import "UIViewController+popUpViewYu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Blur.h"
#import "UIView+Screenshot.h"
#import "DKLiveBlurView.h"

#define SourceViewTag 10001
#define PopupViewTag 10002
#define OverlayViewTag 10003
#define BackgroundViewTag 10004
#define AnimationDuration 0.35

@interface BlurView : UIImageView
-(id)initWithCoverView:(UIView*)view;
@end

#pragma mark BlurView
@implementation BlurView {
    UIView *_coverView;
}

- (id)initWithCoverView:(UIView *)view {
    if (self = [super initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)]) {
        _coverView = view;
        UIImage *blur = [_coverView screenshot];
        self.image = [blur boxblurImageWithBlur:0.2f];
    }
    return self;
}
@end

@implementation UIViewController (popUpViewYu)
//global variable
PopupViewAnimation animationTypeLocal;

-(void)presentPopupViewController:(UIViewController *)popupViewController animationType:(PopupViewAnimation)animationType{
    animationTypeLocal = animationType;
    [self presentPopupView:popupViewController.view animationType:animationType];
}

- (void)dismissPopupViewControllerWithanimationType:(PopupViewAnimation) animationType
{
    UIView *sourceView = [self getTheTopView];
    UIView *popupView = [sourceView viewWithTag:PopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:OverlayViewTag];
    
    if(animationType == SlideBottomTop || animationType == SlideBottomBottom || animationType == SlideTopBottom ||animationType == SlideTopTop || animationType == SlideRightLeft || animationType == SlideLeftRight) {
        [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    } else if(animationType == Fade){
        [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }else if(animationType == Bounce) {
        [self bounceViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }else if (animationType == PushBack){
        [self pushBackViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }else if (animationType == Blur){
        [self blurViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }else if (animationType == Frost){
        [self frostedCustomViewOut:popupView sourceView:sourceView overlayView:overlayView];
    }
}

#pragma mark View Handing
-(void)presentPopupView:(UIView *)popupView animationType:(PopupViewAnimation)animationType{
    UIView *sourceView = [self getTheTopView];
    sourceView.tag = SourceViewTag;
    popupView.tag = PopupViewTag;
    if ([sourceView.subviews containsObject:popupView]) {
        return;
    }
    
    //给弹出框加上左上角的退出按钮,为什么不能完全显示按钮
    popupView.clipsToBounds = YES;
    popupView.layer.masksToBounds = YES;
    
    //增加透明层
    UIView *overlayView = [[UIView alloc]initWithFrame:sourceView.bounds];
    overlayView.tag = OverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    //背景层
    if (animationType == Frost){
        DKLiveBlurView *backgroundView = [[DKLiveBlurView alloc]initWithFrame: sourceView.bounds];
        backgroundView.tag = BackgroundViewTag;
        [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        backgroundView.originalImage = [sourceView screenshot];
        backgroundView.isGlassEffectOn = YES;
        [backgroundView setBlurLevel:0.9];//只要模糊，不需要看清字
        
        [overlayView addSubview:backgroundView];
    }else{
        UIView *backgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.tag = BackgroundViewTag;
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.0f;
        [overlayView addSubview:backgroundView];
    }
    
    //给覆盖层加上隐形的按钮
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    
    [sourceView addSubview:overlayView];
    
    switch (animationType) {
        case SlideBottomTop:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideBottomTop) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case SlideBottomBottom:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideBottomBottom) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case SlideTopBottom:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideTopBottom) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case SlideTopTop:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideTopTop) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case SlideLeftRight:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideLeftRight) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case SlideRightLeft:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideRightLeft) forControlEvents:UIControlEventTouchUpInside];
            [self slideViewIn:popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType];
            break;
        case Fade:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeFade) forControlEvents:UIControlEventTouchUpInside];
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        case Bounce:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeBounce) forControlEvents:UIControlEventTouchUpInside];
            [self bounceViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        case PushBack:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypePushBack) forControlEvents:UIControlEventTouchUpInside];
            [self pushBackViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        case Blur:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeBlur) forControlEvents:UIControlEventTouchUpInside];
            [self blurViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        case Frost:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeFrost) forControlEvents:UIControlEventTouchUpInside];
            [self frostedCustomViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        default:
            break;
    }
}

-(UIView*)getTheTopView {
    UIViewController *recentView = self;
    //只要还有父类控制器，当前视图就往前迭代，直到获得stack顶部的视图并返回
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

//改简单点，可能需要一个全局变量才存储进入的方式
- (void)dismissPopupViewControllerWithanimationTypeSlideBottomTop
{
    [self dismissPopupViewControllerWithanimationType:SlideBottomTop];
}
- (void)dismissPopupViewControllerWithanimationTypeSlideBottomBottom
{
    [self dismissPopupViewControllerWithanimationType:SlideBottomBottom];
}
- (void)dismissPopupViewControllerWithanimationTypeSlideTopBottom
{
    [self dismissPopupViewControllerWithanimationType:SlideTopBottom];
}
- (void)dismissPopupViewControllerWithanimationTypeSlideTopTop
{
    [self dismissPopupViewControllerWithanimationType:SlideTopTop];
}
- (void)dismissPopupViewControllerWithanimationTypeSlideRightLeft
{
    [self dismissPopupViewControllerWithanimationType:SlideRightLeft];
}
- (void)dismissPopupViewControllerWithanimationTypeSlideLeftRight
{
    [self dismissPopupViewControllerWithanimationType:SlideLeftRight];
}
- (void)dismissPopupViewControllerWithanimationTypeFade
{
    [self dismissPopupViewControllerWithanimationType:Fade];
}
- (void)dismissPopupViewControllerWithanimationTypeBounce
{
    [self dismissPopupViewControllerWithanimationType:Bounce];
}
-(void)dismissPopupViewControllerWithanimationTypePushBack{
    [self dismissPopupViewControllerWithanimationType:PushBack];
}
-(void)dismissPopupViewControllerWithanimationTypeBlur{
    [self dismissPopupViewControllerWithanimationType:Blur];
}
-(void)dismissPopupViewControllerWithanimationTypeFrost{
    [self dismissPopupViewControllerWithanimationType:Frost];
}

#pragma mark Slide
-(void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType{
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    if (animationType == SlideBottomTop || animationType == SlideBottomBottom) {
        
        popupStartRect = CGRectMake((sourceSize.width - popupSize.width)/2,
                                    sourceSize.height,
                                    popupSize.width,
                                    popupSize.height);
    }else if (animationType == SlideTopBottom || animationType == SlideTopTop){
        popupStartRect = CGRectMake((sourceSize.width - popupSize.width)/2,
                                    -sourceSize.height,
                                    popupSize.width,
                                    popupSize.height);
    }else if(animationType == SlideRightLeft){
        popupStartRect = CGRectMake(sourceSize.width,
                                    (sourceSize.height - popupSize.height) / 2,
                                    popupSize.width,
                                    popupSize.height);
    }else{
        popupStartRect = CGRectMake(-sourceSize.width,
                                    (sourceSize.height - popupSize.height) / 2,
                                    popupSize.width,
                                    popupSize.height);
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    //设置开始属性
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:AnimationDuration animations:^{
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(PopupViewAnimation)animationType{
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    
    if (animationType == SlideBottomTop || animationType == SlideTopTop) {
        popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                  -popupSize.height,
                                  popupSize.width,
                                  popupSize.height);
    }else if (animationType == SlideBottomBottom || animationType == SlideTopBottom){
        popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                  sourceSize.height,
                                  popupSize.width,
                                  popupSize.height);
    }else if(animationType == SlideRightLeft){
        popupEndRect = CGRectMake(-popupSize.width,
                                  popupView.frame.origin.y,
                                  popupSize.width,
                                  popupSize.height);
    }else{
        popupEndRect = CGRectMake(popupSize.width,
                                  popupView.frame.origin.y,
                                  popupSize.width,
                                  popupSize.height);
    }
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}

#pragma mark Fade
- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    backgroundView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5f;
        backgroundView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.0f;
        backgroundView.transform = CGAffineTransformIdentity;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}

#pragma mark Bounce
- (void)bounceViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6f, 0.6f);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5f;
        backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9f, 0.9f);
        popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self bounceOutAnimationStoped:popupView overlayView:(UIView*)overlayView];
    }];
}

-(void)bounceOutAnimationStoped:(UIView*)popupView overlayView:(UIView*)overlayView{
    [UIView animateWithDuration:0.2 animations:^{
        popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9f, 0.9f);
    } completion:^(BOOL finished) {
        [self bounceInAnimationStoped:popupView overlayView:(UIView*)overlayView];
    }];
}

-(void)bounceInAnimationStoped:(UIView*)popupView overlayView:(UIView*)overlayView{
    [UIView animateWithDuration:0.2 animations:^{
        popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
    } completion:^(BOOL finished) {
    
    }];
}

-(void)closeAction:(id)sender{
    switch (animationTypeLocal) {
        case SlideBottomTop:
            [self dismissPopupViewControllerWithanimationType:SlideBottomTop];
            break;
        case SlideBottomBottom:
            [self dismissPopupViewControllerWithanimationType:SlideBottomBottom];
            break;
        case SlideTopBottom:
            [self dismissPopupViewControllerWithanimationType:SlideTopBottom];
            break;
        case SlideTopTop:
            [self dismissPopupViewControllerWithanimationType:SlideTopTop];
            break;
        case SlideRightLeft:
            [self dismissPopupViewControllerWithanimationType:SlideLeftRight];
            break;
        case SlideLeftRight:
            [self dismissPopupViewControllerWithanimationType:SlideLeftRight];
            break;
        case Fade:
            [self dismissPopupViewControllerWithanimationType:Fade];
            break;
        case Bounce:
            [self dismissPopupViewControllerWithanimationType:Bounce];
            break;
        case PushBack:
            [self dismissPopupViewControllerWithanimationType:PushBack];
            break;
        case Blur:
            [self dismissPopupViewControllerWithanimationType:Blur];
            break;
        case Frost:
            [self dismissPopupViewControllerWithanimationType:Frost];
            break;
        default:
            break;
    }
}

- (void)bounceViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.0f;
        backgroundView.transform = CGAffineTransformIdentity;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}

#pragma mark PushBack
-(void)pushBackViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.35f;
        CALayer *layer = backgroundView.layer;
        layer.zPosition = -4000;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -300;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, 10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            backgroundView.alpha = 0.5;
            popupView.alpha = 1.0;
        }];
    }];
    
}

- (void)pushBackViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    [UIView animateWithDuration:0.4 animations:^{
        CALayer *layer = backgroundView.layer;
        layer.zPosition = -4000;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 300;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        backgroundView.alpha = 0.35;
        popupView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        self.view.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.3 animations:^{
            [popupView removeFromSuperview];
            [overlayView removeFromSuperview];
        }];
    }];
}

#pragma mark frost
- (void)frostedCustomViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    [UIView animateWithDuration:AnimationDuration animations:^{
        backgroundView.alpha = 1.0f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)frostedCustomViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    [UIView animateWithDuration:AnimationDuration animations:^{
        backgroundView.alpha = 0.0f;
        backgroundView.transform = CGAffineTransformIdentity;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}

#pragma mark Blur
- (void)blurViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    UIImage *blurImage = [sourceView screenshot];
    UIImage *image = [blurImage boxblurImageWithBlur:0.2f];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.alpha = 1.0f;
    [backgroundView addSubview:imageView];
    
    
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    //backgroundView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:AnimationDuration animations:^{
        backgroundView.alpha = 1.0f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)blurViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:BackgroundViewTag];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.0f;
        backgroundView.transform = CGAffineTransformIdentity;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}

@end