//
//  WXDActivityIndicator.m
//  Protoshop
//
//  Created by kuolei on 8/7/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDActivityIndicator.h"

@interface WXDActivityIndicator ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isCleared;
@property (nonatomic, assign) BOOL isUnstep;

@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger animationStep;


@end

@implementation WXDActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _isCleared = NO;
        _isUnstep = NO;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _isCleared = NO;
        _isUnstep = NO;
    }
    
    return self;
}

-(void) awakeFromNib
{
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGPoint point;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFlush(ctx);

    if (_isCleared == YES) {
        CGContextClearRect(ctx, self.bounds);
    } else {
        CGContextSetLineWidth(ctx, 2.0);
        
        if (_timer.isValid) {
            for (NSInteger i = 1 ; i < 11; ++i) {
                CGContextSetStrokeColorWithColor(ctx, [[self getColorForStage:_animationStep + i WithAlpha:0.1 *i] CGColor]);
                
                point = [self pointOnOuterCirecleWithAngel:_animationStep + i];
                CGContextMoveToPoint(ctx, point.x, point.y);
                point = [self pointOnInnerCirecleWithAngel:_animationStep + i];
                CGContextAddLineToPoint( ctx, point.x, point.y);
                CGContextStrokePath(ctx);
            }
            _animationStep++;
        } else {
            if (!_isUnstep) {
                if (_step < 12) {
                    for (NSInteger i = 1 ; i < _step; ++i) {
                        CGContextSetStrokeColorWithColor(ctx, [[self getColorForStage:_animationStep + i WithAlpha:0.1 *i] CGColor]);
                        
                        point = [self pointOnOuterCirecleWithAngel:_animationStep + i];
                        CGContextMoveToPoint(ctx, point.x, point.y);
                        point = [self pointOnInnerCirecleWithAngel:_animationStep + i];
                        CGContextAddLineToPoint( ctx, point.x, point.y);
                        CGContextStrokePath(ctx);
                    }
                } else {
                    for (NSInteger i = 1 ; i < 11; ++i) {
                        CGContextSetStrokeColorWithColor(ctx, [[self getColorForStage:_animationStep + i WithAlpha:0.1 *i] CGColor]);
                        
                        point = [self pointOnOuterCirecleWithAngel:_animationStep + i];
                        CGContextMoveToPoint(ctx, point.x, point.y);
                        point = [self pointOnInnerCirecleWithAngel:_animationStep + i];
                        CGContextAddLineToPoint( ctx, point.x, point.y);
                        CGContextStrokePath(ctx);
                    }
                }
                _animationStep++;
            } else {
                for (NSInteger i = 1 ; i < 11; ++i) {
                    CGContextSetStrokeColorWithColor(ctx, [[self getColorForStage:_animationStep + i WithAlpha:0.1 *i] CGColor]);
                    
                    point = [self pointOnOuterCirecleWithAngel:_animationStep + i];
                    CGContextMoveToPoint(ctx, point.x, point.y);
                    point = [self pointOnInnerCirecleWithAngel:_animationStep + i];
                    CGContextAddLineToPoint( ctx, point.x, point.y);
                    CGContextStrokePath(ctx);
                }
                _animationStep--;
            }
        }
    }
}


/**
 Clear the view context
 */
-(void) clear
{
    _step = 0;
    _animationStep = 0;
    _isCleared = YES;
    [self setNeedsDisplay];
}


/**
 the animation step by step
 */
-(void) progress:(NSInteger) progress
{
    _isCleared = NO;
    _step = progress;
    _isUnstep = NO;
    [self setNeedsDisplay];
}

-(void) unprogress:(NSInteger) progress
{
    _isCleared = NO;
    _isUnstep = YES;
    [self setNeedsDisplay];
}

/**
 start indicator animation
 */
-(void) startAnimation
{
    _isCleared = NO;
    _isUnstep = NO;
    if (!_timer.isValid) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    self.hidden = NO;
}


/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self clear];
}


/**
 stop indicator animation
 */
-(void) stopAnimation
{
    [_timer invalidate];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.0;
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1.0;
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:rotationAnimation, scaleAnimation, opacityAnimation, nil];
    animationGroup.duration = 1.0;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.repeatCount = 1.0;
    animationGroup.delegate = self;
    
    [self.layer addAnimation:animationGroup forKey:nil];
}

-(UIColor *) getColorForStage:(NSInteger) currentStage WithAlpha:(double) alpha
{
//    int max = 20;
//    int cycle = currentStage % max;
    
//    [UIColor darkGrayColor];
    
//    CGFloat alpha = 1.0 - (stepIndex % _steps) * (1.0 / _steps);
//    
//    return [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(_color.CGColor, alpha)];
//    if (cycle < max/4) {
//        return [UIColor colorWithRed:66.0/255.0 green:72.0/255.0 blue:101.0/255.0 alpha:alpha];
//    } else if (cycle < max/4*2) {
//        return [UIColor colorWithRed:238.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:alpha];
//    } else if (cycle < max/4*3) {
//        return [UIColor colorWithRed:33.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:alpha];
//        
//    } else  {
//        return [UIColor colorWithRed:251.0/255.0 green:184.0/255.0 blue:18.0/255.0 alpha:alpha];
//    }
   return [UIColor colorWithRed:66.0/255.0 green:72.0/255.0 blue:101.0/255.0 alpha:alpha];
    
  
}

-(CGPoint) pointOnInnerCirecleWithAngel:(NSInteger) angel
{
    double r = self.frame.size.height/2/2;
    double cx = self.frame.size.width/2;
    double cy = self.frame.size.height/2;
    double x = cx + r*cos(M_PI/10*angel);
    double y = cy + r*sin(M_PI/10*angel);
    return CGPointMake(x, y);
}

-(CGPoint) pointOnOuterCirecleWithAngel:(NSInteger) angel
{
    double r = self.frame.size.height/2;
    double cx = self.frame.size.width/2;
    double cy = self.frame.size.height/2;
    double x = cx + r*cos(M_PI/10*angel);
    double y = cy + r*sin(M_PI/10*angel);
    return CGPointMake(x, y);
}

@end
