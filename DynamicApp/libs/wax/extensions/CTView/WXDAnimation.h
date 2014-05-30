//
//  WXDAnimation.h
//  Protoshop
//
//  Created by Anselz on 14-4-24.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#ifndef Protoshop_WXDAnimation_h
#define Protoshop_WXDAnimation_h

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

#endif
