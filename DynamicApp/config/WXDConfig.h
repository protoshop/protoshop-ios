//
//  config.h
//  Protoshop
//
//  Created by kuolei on 12/9/13.
//  Copyright (c) 2013 kuolei. All rights reserved.
//
//  Protoshop 配置文件
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import"WXDBaseViewController.h"

#ifndef __PROTOSHOP_CONFIG_H__
#define __PROTOSHOP_CONFIG_H__

//#define PROTOSHOP_DEBUG     //DEBUG PROJECT

#define MARK    NSLog(@"\nMARK: %s, %d", __PRETTY_FUNCTION__, __LINE__)

#define NavigationBar_HEIGHT 44.0f
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//GCD
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
#define IMAGE_NAMED(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define LOAD_IMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

// UIColorFromRGB(0xffffff);
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// UIFont
#define SET_FONT(className,fontName,fontSize) [className setFont:[UIFont fontWithName:fontName size:fontSize]]

// Alert
#define SHOW_ALERT(title,content) [[[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

// DOCUMENTS_DIRECTORY
#define DOCUMENTS_DIRECTORY [[[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath]
// Caches directory NSCachesDirectory
#define CACHES_DIRECTORY [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject] relativePath]

// Singleton
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+(className* )shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
@synchronized(self){ \
shared##className = [[self alloc] init]; \
} \
}); \
return shared##className; \
}

#ifdef PROTOSHOP_DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif //PROTOSHOP_DEBUG


#endif //__PROTOSHOP_CONFIG_H__