//
//  UIImage+Blur.h
//  PopupViewByhlyu
//
//  Created by hlyu on 13-9-16.
//  Copyright (c) 2013年 HongliYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end