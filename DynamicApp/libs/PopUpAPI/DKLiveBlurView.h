//
//  DKLiveBlurView.h
//  LiveBlur
//
//  Created by Dmitry Klimkin on 16/6/13.
//  Copyright (c) 2013 Dmitry Klimkin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDKBlurredBackgroundDefaultLevel 0.8f
#define kDKBlurredBackgroundDefaultGlassColor [UIColor grayColor]

@interface DKLiveBlurView : UIImageView

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, assign) float initialBlurLevel;
@property (nonatomic, assign) float initialGlassLevel;
@property (nonatomic, assign) BOOL isGlassEffectOn;
@property (nonatomic, strong) UIColor *glassColor;

- (void)setBlurLevel:(float)blurLevel;

@end