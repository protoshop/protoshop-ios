//
//  CTLoginWebView.m
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import "CTLoginWebView.h"
#import <QuartzCore/QuartzCore.h>
#import "CTSSOAuthDelegate.h"
#import "authconfig.h"

#define SUBVIEW_ORIGINX 20
#define SUBVIEW_ORIGINY 20


@interface CTLoginWebView ()<UIWebViewDelegate>

@property (nonatomic,assign)id<CTSSOAuthDelegate>delegate;

@end

@implementation CTLoginWebView

-(id)initWithDelegate:(id)delegate
{
    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    self = [self initWithFrame: window.bounds];
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

-(void)initBaseView
{
    CGRect frame = self.bounds;
    CGFloat originX = SUBVIEW_ORIGINX;
    CGFloat originY = SUBVIEW_ORIGINY;
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(originX, originY, frame.size.width - 2*originX, frame.size.height - 2* originY)];
    UIWebView *web = [[UIWebView alloc]initWithFrame:baseView.bounds];
    web.delegate = self;
    web.scalesPageToFit = YES;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:AUTH_URL]]];
    [baseView addSubview:web];
    baseView.clipsToBounds = YES;
    baseView.layer.cornerRadius = 10.0;
    baseView.layer.borderWidth = 5;
    baseView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:baseView];
    
     baseView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:0.2 animations:^{
         baseView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            baseView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                 baseView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 24, 24)];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:backButton];
}

-(void)closeViewAction:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
        if (self) {
            [self removeFromSuperview];
        }
    }
}
-(void)show
{
    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
}
@end
