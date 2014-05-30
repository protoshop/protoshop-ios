//
//  CTButton
//  ToHell2iOS
//
//  Created by Anselz on 14-1-6.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "CTButton.h"

@interface CTButton ()


@end

@implementation CTButton
@synthesize actionModel;

#pragma mark - --------------------退出清空--------------------

#pragma mark - --------------------初始化--------------------

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)initData
{
    self.actionModel = [[CTActionModel alloc]init];
}
#pragma mark - --------------------System--------------------

#pragma mark - --------------------功能函数--------------------

#pragma mark - --------------------手势事件--------------------

#pragma mark - --------------------按钮事件--------------------

#pragma mark - --------------------代理方法--------------------

#pragma mark - --------------------属性相关--------------------

#pragma mark - --------------------接口API--------------------



@end
