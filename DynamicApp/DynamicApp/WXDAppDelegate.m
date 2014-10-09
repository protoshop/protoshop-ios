//
//  AppDelegate.m
//  DynamicApp
//
//  Created by new_ctrip on 13-6-13.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import "WXDAppDelegate.h"
#import "WXDProjectsViewController.h"
#import "WXDLoginViewController.h"
#import "WXDUserInfo.h"

@implementation WXDAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Reachability *reachability = [Reachability reachabilityWithHostname:__reachability_path];
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"Block Says Reachable");
        });
    };
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"Block Says Unreachable");
            [[[UIAlertView alloc] initWithTitle:@"网络状况" message:@"失去连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
    };
    [reachability startNotifier];
    
    UINavigationController *nav = [[UINavigationController alloc]init];
        
    if ([USER_DEFAULT objectForKey:@"userEmail"]!=nil && [USER_DEFAULT objectForKey:@"userToken"]!=nil) {
        WXDProjectsViewController *mainViewController = [[WXDProjectsViewController alloc]init];
        [nav pushViewController:mainViewController animated:NO];
    }else {
        WXDLoginViewController *loginViewController = [[WXDLoginViewController alloc] init];
        [nav pushViewController:loginViewController animated:NO];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    DLog(@"%@",DOCUMENTS_DIRECTORY);
    return YES;
}

/**
 *  打印log到documents目录
 */
- (void)redirectLogToDocumentFolder
{
#ifndef PROTOSHOP_WWW
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    NSString *logFilePath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:fileName];
    /**
     *  先删除已经存在的文件
     */
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    /**
     *  将log输入到文件
     */
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
#endif
}

/**
 *  注册推送服务
 *
 *  @param application The app object that initiated the remote-notification registration process.
 *  @param deviceToken A token that identifies the device to APS. The token is an opaque data type because that is the form that the provider needs to submit to the APS servers when it sends a notification to a device. The APS servers require a binary format for performance reasons.
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0){
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_register_device:[USER_DEFAULT objectForKey:@"userToken"]
                                devicetoken:deviceToken
                                    success:^(NSInteger state) {
                                        SHOW_ALERT(@"注册推送服务", @"成功");
    } failure:^(NSError *error) {
        SHOW_ALERT(@"注册推送服务", @"失败");
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
