//
//  UINavigationController+hlyu.h
//  DynamicNavigation
//
//  Created by HongliYu on 14-4-21.
//  Copyright (c) 2014年 HongliYu. All rights reserved.
//

#import <UIKit/UIKit.h>
//动画类型 1.Push 2.Cover 3.None
typedef enum {
    kSceneTransitionNone = 0,
    kSceneTransitionPush = 1,
    kSceneTransitionCover = 2,
}kSceneTransitionType;

//动画方向1.Left 2.Right 3.Up 4.Down
typedef enum {
    kSceneTransitionDirectionNone = 0,
    kSceneTransitionDirectionLeft = 1,
    kSceneTransitionDirectionRight = 2,
    kSceneTransitionDirectionUp = 3,
    kSceneTransitionDirectionDown = 4,
}kSceneTransitionDirectionType;

@interface UINavigationController (hlyu)
-(void)pushViewControllerFrom:(UIViewController *)currentVC
                           to:(UIViewController *)nextVC
               animatType:(kSceneTransitionType)type
                direction:(kSceneTransitionDirectionType)direction
                delayTime:(float)interval;

- (void)popViewControllerFrom:(UIViewController *)currentVC
                   animatType:(kSceneTransitionType)type
                    direction:(kSceneTransitionDirectionType)direction
                    delayTime:(float)interval;
@end
