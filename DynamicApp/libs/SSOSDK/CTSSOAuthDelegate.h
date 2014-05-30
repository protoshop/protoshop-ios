//
//  CTSSOAuthDelegate.h
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTSSOAuthDelegate <NSObject>

-(void)authSuccess:(NSDictionary *)userInfo;
@end
