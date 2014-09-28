//
//  WXDActivityIndicator.h
//  Protoshop
//
//  Created by kuolei on 8/7/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXDActivityIndicator : UIView

-(void) clear;
-(void) progress:(NSInteger) progress;
-(void) unprogress:(NSInteger) progress;
-(void) startAnimation;
-(void) stopAnimation;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger animationStep;
@end
