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
-(void) step;
-(void) unstep;
-(void) startAnimation;
-(void) stopAnimation;

@end
