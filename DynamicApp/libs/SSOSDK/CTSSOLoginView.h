//
//  CTSSOLoginView.h
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSSOAuthDelegate.h"

@interface CTSSOLoginView : UIView

@property (nonatomic,assign)id<CTSSOAuthDelegate>delegate;

-(id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
@end
