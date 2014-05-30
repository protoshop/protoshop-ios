//
//  CTSSOLoginView.m
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import "CTSSOLoginView.h"
#import "CTSSOAuthDelegate.h"
#import "authconfig.h"


@interface CTSSOLoginView ()<UIWebViewDelegate>

@end


@implementation CTSSOLoginView


-(id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self initBaseView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initBaseView];
}

-(void)initBaseView
{
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.bounds];
    web.delegate = self;
    web.scalesPageToFit = YES;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:AUTH_URL]]];
    [self addSubview:web];
    
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *currentURL= webView.request.URL.absoluteString;
//    NSLog(@"%@",currentURL);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self checkAuthStatus:nil];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(void)checkAuthStatus:(id)sender
{
    NSString *resultStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:CHECK_AUTH_URL] encoding:NSUTF8StringEncoding error:nil];
    NSRange range = [resultStr rangeOfString:@"1002"];
    if (range.length <=0)
    {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSMutableDictionary *dict = [jsonParser objectWithString:resultStr];
        if (self.delegate && [self.delegate respondsToSelector:@selector(authSuccess:)]) {
            [self.delegate authSuccess:dict];
        }
    }
}

@end
