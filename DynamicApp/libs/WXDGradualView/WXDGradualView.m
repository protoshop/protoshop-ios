//
//  gradualView.m
//  Protoshop
//
//  Created by HongliYu on 14-1-20.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "WXDGradualView.h"

@implementation WXDGradualView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:33/255.0 green:109/255.0 blue:201/255.0 alpha:1.0].CGColor,
                       (id)[UIColor colorWithRed:11/255.0 green:81/255.0 blue:179/255.0 alpha:1.0].CGColor,nil];
    [self.layer insertSublayer:gradient atIndex:0];
}

@end