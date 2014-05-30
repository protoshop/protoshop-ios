//
//  AppDelegate.h
//  DynamicApp
//
//  Created by new_ctrip on 13-6-13.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "WXDRequestCommand.h"

Reachability *WXDreach;
@class WXDProjectsViewController;
@interface WXDAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end