//
//  CTView.m
//  Animation
//
//  Created by Anselz on 13-12-4.
//  Copyright (c) 2013年 Anselz. All rights reserved.
//
//  扩展UIView
//  创建人 Anselz(赵发凯)
//  创建时间 2012-12-4

#import "CTView.h"
#import <QuartzCore/QuartzCore.h>
@interface CTView ()
{
    
}

@end
@implementation CTView

#pragma mark - --------------------退出清空--------------------

#pragma mark - --------------------初始化--------------------
- (id)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - --------------------System--------------------

#pragma mark - --------------------功能函数--------------------

#pragma mark - --------------------手势事件--------------------

#pragma mark - --------------------按钮事件--------------------

#pragma mark - --------------------代理方法--------------------

#pragma mark - --------------------属性相关--------------------

#pragma mark - --------------------接口API--------------------

/**
 设置背景图片
 
 @param imagePath  背景图片名称
 
 @return nil 不需要返回值
 
 */
-(void)setBackgroundImage:(NSString *)imagePath
{
    if (imagePath.length <= 0) {
        return;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image == nil) {
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = image;
    [self addSubview:imageView];
}
/**
 添加视图子View
 
 @param dic  子View相关属性的字典
 
 @return nil 不需要返回值
 
 */
-(void)addCTSubView:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
}

-(void)addEvent:(UIButton*)Btn event:(NSString*)theEvent{
    if ([theEvent isEqualToString:@""]==YES) {
        return;
    }
    
    SEL selector = NSSelectorFromString(theEvent);
    [Btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)clickAction:(id)target
        animatType:(kSceneTransitionType)type
         direction:(kSceneTransitionDirectionType)direction
         delayTime:(float)interval
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHotzoneWith:target:animatType:direction:delayTime:)]) {
        [self.delegate clickHotzoneWith:self target:target animatType:type direction:direction delayTime:0.25];
    }
}

-(id)command:(UIView*)contentView createView:(NSDictionary*)dic{
    
    NSDictionary *frameDic = [dic objectForKey:@"frame"];
    float originX = [[frameDic objectForKey:@"originX"]floatValue];
    float originY = [[frameDic objectForKey:@"originY"]floatValue];
    float sizeWidth = [[frameDic objectForKey:@"sizeWidth"]floatValue];
    float sizeHeight = [[frameDic objectForKey:@"sizeHeight"]floatValue];
    
    NSDictionary *colorDic = [dic objectForKey:@"bkColor"];
    float bkColorRed = [[colorDic objectForKey:@"bkColorRed"]floatValue];
    float bkColorGreen = [[colorDic objectForKey:@"bkColorGreen"]floatValue];
    float bkColorBlue = [[colorDic objectForKey:@"bkColorBlue"]floatValue];
    float bkAlpha = [[colorDic objectForKey:@"bkAlpha"]floatValue];
    
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(originX, originY, sizeWidth, sizeHeight)];
    [newView setBackgroundColor:[UIColor colorWithRed:bkColorRed green:bkColorGreen blue:bkColorBlue alpha:bkAlpha]];
    [contentView addSubview:newView];
    return newView;
}

-(id)command:(UIView*)contentView createBtn:(NSDictionary*)dic{
    
    NSDictionary *frameDic = [dic objectForKey:@"frame"];
    float originX = [[frameDic objectForKey:@"originX"]floatValue];
    float originY = [[frameDic objectForKey:@"originY"]floatValue];
    float sizeWidth = [[frameDic objectForKey:@"sizeWidth"]floatValue];
    float sizeHeight = [[frameDic objectForKey:@"sizeHeight"]floatValue];
    
    NSDictionary *colorDic = [dic objectForKey:@"bkColor"];
    float bkColorRed = [[colorDic objectForKey:@"bkColorRed"]floatValue];
    float bkColorGreen = [[colorDic objectForKey:@"bkColorGreen"]floatValue];
    float bkColorBlue = [[colorDic objectForKey:@"bkColorBlue"]floatValue];
    float bkAlpha = [[colorDic objectForKey:@"bkAlpha"]floatValue];
    
    NSDictionary *titleDic = [dic objectForKey:@"titleInfo"];
    NSString *titleText = [titleDic objectForKey:@"titleText"];
    UIControlState controlState = [[titleDic objectForKey:@"controlState"]integerValue];
    float fontSize = [[titleDic objectForKey:@"fontSize"]floatValue];
    int alignment = [[titleDic objectForKey:@"alignment"]floatValue];
    
    NSDictionary *titleColor = [titleDic objectForKey:@"titleColor"];
    float titleColorRed = [[titleColor objectForKey:@"titleColorRed"]floatValue];
    float titleColorGreen = [[titleColor objectForKey:@"titleColorGreen"]floatValue];
    float titleColorBlue = [[titleColor objectForKey:@"titleColorBlue"]floatValue];
    float titleAlpha = [[titleColor objectForKey:@"titleAlpha"]floatValue];
    
    UIButtonType btnType =  [[dic objectForKey:@"btnType"]integerValue];
    
    UIButton *Btn = [UIButton buttonWithType:btnType];
    Btn.frame = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    Btn.backgroundColor = [UIColor colorWithRed:bkColorRed green:bkColorGreen blue:bkColorBlue alpha:bkAlpha];
    [Btn setTitle:titleText forState:controlState];
    [Btn setTitleColor:[UIColor colorWithRed:titleColorRed green:titleColorGreen blue:titleColorBlue alpha:titleAlpha] forState:controlState];
    Btn.titleLabel.textAlignment = alignment;
    Btn.titleLabel.font = [UIFont systemFontOfSize: fontSize];
    [contentView addSubview:Btn];
    return Btn;
}

-(id)command:(UIView*)contentView createImageview:(NSDictionary*)dic{
    
    NSDictionary *frameDic = [dic objectForKey:@"frame"];
    float originX = [[frameDic objectForKey:@"originX"]floatValue];
    float originY = [[frameDic objectForKey:@"originY"]floatValue];
    float sizeWidth = [[frameDic objectForKey:@"sizeWidth"]floatValue];
    float sizeHeight = [[frameDic objectForKey:@"sizeHeight"]floatValue];
    NSString *imageName = [dic objectForKey:@"imageName"];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imageName]];
    imageView.frame = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    [contentView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    return imageView;
    
}

-(id)command:(UIView*)contentView createLabel:(NSDictionary*)dic{
    
    NSDictionary *frameDic = [dic objectForKey:@"frame"];
    float originX = [[frameDic objectForKey:@"originX"]floatValue];
    float originY = [[frameDic objectForKey:@"originY"]floatValue];
    float sizeWidth = [[frameDic objectForKey:@"sizeWidth"]floatValue];
    float sizeHeight = [[frameDic objectForKey:@"sizeHeight"]floatValue];
    NSDictionary *colorDic = [dic objectForKey:@"bkColor"];
    float bkColorRed = [[colorDic objectForKey:@"bkColorRed"]floatValue];
    float bkColorGreen = [[colorDic objectForKey:@"bkColorGreen"]floatValue];
    float bkColorBlue = [[colorDic objectForKey:@"bkColorBlue"]floatValue];
    float bkAlpha = [[colorDic objectForKey:@"bkAlpha"]floatValue];
    
    NSDictionary *textDic = [dic objectForKey:@"textInfo"];
    NSString* fontName = [textDic objectForKey:@"fontName"];
    float fontSize = [[textDic objectForKey:@"fontSize"]floatValue];
    NSString *lableText = [textDic objectForKey:@"text"];
    int alignment = [[textDic objectForKey:@"alignment"]floatValue];
    
    NSDictionary *textColor = [textDic objectForKey:@"textColor"];
    float textColorRed = [[textColor objectForKey:@"textColorRed"]floatValue];
    float textColorGreen = [[textColor objectForKey:@"textColorGreen"]floatValue];
    float textColorBlue = [[textColor objectForKey:@"textColorBlue"]floatValue];
    float textAlpha = [[textColor objectForKey:@"textAlpha"]floatValue];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, sizeWidth, sizeHeight)];
    [label setBackgroundColor:[UIColor colorWithRed:bkColorRed green:bkColorGreen blue:bkColorBlue alpha:bkAlpha]];
    
    if ([fontName isEqualToString:@"system"] == YES) {
        fontName = @"Helvetica";
    }
    
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.text = lableText;
    [label setTextAlignment:(NSTextAlignment)alignment];
    [label setTextColor:[UIColor colorWithRed:textColorRed green:textColorGreen blue:textColorBlue alpha:textAlpha]];
    [contentView addSubview:label];
    return label;
    
}

-(id)command:(UIView*)contentView createScrollView:(NSDictionary*)dic{
    NSDictionary *frameDic = [dic objectForKey:@"frame"];
    float originX = [[frameDic objectForKey:@"originX"]floatValue];
    float originY = [[frameDic objectForKey:@"originY"]floatValue];
    float sizeWidth = [[frameDic objectForKey:@"sizeWidth"]floatValue];
    float sizeHeight = [[frameDic objectForKey:@"sizeHeight"]floatValue];
    
    NSDictionary *colorDic = [dic objectForKey:@"bkColor"];
    float bkColorRed = [[colorDic objectForKey:@"bkColorRed"]floatValue];
    float bkColorGreen = [[colorDic objectForKey:@"bkColorGreen"]floatValue];
    float bkColorBlue = [[colorDic objectForKey:@"bkColorBlue"]floatValue];
    float bkAlpha = [[colorDic objectForKey:@"bkAlpha"]floatValue];
    
    NSDictionary *contentOffset = [dic objectForKey:@"contentOffset"];
    float anchorOriginX = [[contentOffset objectForKey:@"anchorOriginX"]floatValue];
    float anchorOriginY = [[contentOffset objectForKey:@"anchorOriginY"]floatValue];
    
    NSDictionary *contentSize = [dic objectForKey:@"contentSize"];
    float contentSizeWidth = [[contentSize objectForKey:@"contentSizeWidth"]floatValue];
    float contentSizeHeight = [[contentSize objectForKey:@"contentSizeHeight"]floatValue];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(originX, originY, sizeWidth, sizeHeight)];
    [scrollView setBackgroundColor:[UIColor colorWithRed:bkColorRed green:bkColorGreen blue:bkColorBlue alpha:bkAlpha]];
    scrollView.contentOffset = CGPointMake(anchorOriginX, anchorOriginY);
    scrollView.contentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
    
    //有定制的另外加
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = NO;
    scrollView.pagingEnabled = NO;
    [contentView addSubview:scrollView];
    return scrollView;
    
}

@end
