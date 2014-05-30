//
//  messageBoxViewController.h
//  DynamicApp
//
//  Created by HongliYu on 13-12-3.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXDConfig.h"

@class messageBoxViewController;
@protocol interactiveDelegate <NSObject>
@optional
-(void)cancelButtonClicked:(messageBoxViewController*) messageBoxVC;
-(void)backButtonClicked:(messageBoxViewController*) messageBoxVC;
@end

@interface messageBoxViewController : UIViewController
@property id<interactiveDelegate> delegate;

@end
