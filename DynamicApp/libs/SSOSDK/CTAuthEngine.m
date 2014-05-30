//
//  CTAuthEngine.m
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import "CTAuthEngine.h"
#import "authconfig.h"
#import "CTLoginWebView.h"
#import "SSOAuthViewController.h"

@implementation CTAuthEngine

+(void)startSSOAuth:(id<CTSSOAuthDelegate>)delegate
{
    [CTAuthEngine startSSOAuth:delegate withType:eAuthTypeDefault];
}

+(void)startSSOAuth:(id<CTSSOAuthDelegate>)delegate withType:(eAuthType)type
{
    NSString *resultStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:CHECK_AUTH_URL] encoding:NSUTF8StringEncoding error:nil];
    NSRange range = [resultStr rangeOfString:@"1002"];
    if (range.length <= 0)
    {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:resultStr];
        if (delegate && [delegate respondsToSelector:@selector(authSuccess:)]) {
            [delegate authSuccess:dict];
        }
    } else {
        if (type == eAuthTypeDefault) {
            CTLoginWebView *login = [[CTLoginWebView alloc]initWithDelegate:delegate];
            [login show];
        } else {
            UIViewController *VC = (UIViewController *)delegate;
            SSOAuthViewController *next = [[SSOAuthViewController alloc]init];
            next.delegate = delegate;
            [VC.navigationController pushViewController:next animated:YES];
        }
    }

}

+(BOOL)logout
{
    NSString *resultStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:LOGOUT_URL] encoding:NSUTF8StringEncoding error:nil];
    DLog(@"%@",resultStr);
    NSRange range = [resultStr rangeOfString:@"1002"];
    if (range.length > 0){
        return YES;
    }
    return NO;
}

@end
