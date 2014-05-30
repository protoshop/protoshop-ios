//
//  SSOAuthViewController.h
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSSOAuthDelegate.h"

@interface SSOAuthViewController : UIViewController

@property (nonatomic,assign) id<CTSSOAuthDelegate>delegate;

@end
