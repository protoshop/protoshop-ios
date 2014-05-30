//
//  DKLiveBlurView.m
//  LiveBlur
//
//  Created by Dmitry Klimkin on 16/6/13.
//  Copyright (c) 2013 Dmitry Klimkin. All rights reserved.
//

#import "DKLiveBlurView.h"
#import <Accelerate/Accelerate.h>

@interface DKLiveBlurView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *backgroundGlassView;

@end

@implementation DKLiveBlurView

@synthesize originalImage = _originalImage;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize initialBlurLevel = _initialBlurLevel;
@synthesize backgroundGlassView = _backgroundGlassView;
@synthesize isGlassEffectOn = _isGlassEffectOn;
@synthesize glassColor = _glassColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _initialBlurLevel = kDKBlurredBackgroundDefaultLevel;
        _glassColor = kDKBlurredBackgroundDefaultGlassColor;

        _backgroundImageView = [[UIImageView alloc] initWithFrame: self.bounds];
        
        _backgroundImageView.alpha = 0;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview: _backgroundImageView];
        
        _backgroundGlassView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundGlassView.alpha = 0;
        _backgroundGlassView.backgroundColor = kDKBlurredBackgroundDefaultGlassColor;
        _backgroundGlassView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview: _backgroundGlassView];
    }
    return self;
}

- (void)setGlassColor:(UIColor *)glassColor {
    _glassColor = glassColor;
    _backgroundGlassView.backgroundColor = glassColor;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 180);//颗粒大小
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
//    self.image = originalImage;
    UIImage *blurredImage = [self blurryImage: self.originalImage withBlurLevel: self.initialBlurLevel];
    self.backgroundImageView.alpha = 0;
    self.backgroundImageView.image = blurredImage;
}

- (void)setBlurLevel:(float)blurLevel {
    self.backgroundImageView.alpha = blurLevel;
    if (self.isGlassEffectOn) {
        self.backgroundGlassView.alpha = 0.5;
    }
}
@end