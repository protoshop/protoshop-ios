//
//  CTView.h
//  Animation
//
//  Created by Anselz on 13-12-4.
//  Copyright (c) 2013年 Anselz. All rights reserved.
//  扩展UIView
//  创建人 Anselz(赵发凯)
//  创建时间 2012-12-4

#import <UIKit/UIKit.h>
#import "WXDAnimation.h"

@protocol CTViewDelegate <NSObject>

-(void)clickHotzoneWith:(id)current
                 target:(id)target
             animatType:(kSceneTransitionType)type
              direction:(kSceneTransitionDirectionType)direction
              delayTime:(float)interval;
@end
/** 扩展UIView*/
@interface CTView : UIView

@property (nonatomic,assign) id<CTViewDelegate> delegate;


/**
 设置背景图片
 
 @param imagePath  背景图片名称
 
 @return nil 不需要返回值
 
 */
-(void)setBackgroundImage:(NSString *)imagePath;

/**
 添加视图子View
 
 @param dic  子View相关属性的字典
 
 @return nil 不需要返回值
 
 */
-(void)addCTSubView:(NSDictionary *)dic;

//在UIbutton上增加事件
-(void)addEvent:(UIButton*)Btn event:(NSString*)theEvent;
//在contentView上加UIView
-(id)command:(UIView*)contentView createView:(NSDictionary*)dic;
//在contentView上加UIbutton
-(id)command:(UIView*)contentView createBtn:(NSDictionary*)dic;
//在contentView上加UIImageView
-(id)command:(UIView*)contentView createImageview:(NSDictionary*)dic;
//在contentView上加UILabel
-(id)command:(UIView*)contentView createLabel:(NSDictionary*)dic;
//在contentView上加scrollView
-(id)command:(UIView*)contentView createScrollView:(NSDictionary*)dic;

-(void)clickAction:(id)target
        animatType:(kSceneTransitionType)type
         direction:(kSceneTransitionDirectionType)direction
         delayTime:(float)interval;
@end
