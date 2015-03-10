//
//  WXDBaseViewController.m
//  Protoshop
//
//  Created by kuolei on 3/20/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//
//  Protoshop 基类控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import "WXDBaseViewController.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface WXDBaseViewController ()
@end

@implementation WXDBaseViewController
#pragma mark - --------------------初始化--------------------
- (id)initWithNavTitle:(NSString*)title{
    self = [super init];
    if (self) {
        [self setBaseNavigationWithTitle:title];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Add Reachability Observer
        bReachability = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Reachability *reachability = [Reachability reachabilityWithHostname:__reachability_path];
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            bReachability = YES;
        });
    };
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            bReachability = NO;
            [[[UIAlertView alloc] initWithTitle:@"网络状况" message:@"失去连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
    };

}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - --------------------功能函数--------------------
- (void)setBaseNavigationWithTitle:(NSString *)title{
    _navLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _navLabel.text = @"";
    SET_FONT(_navLabel,@"FontAwesome",24.0);
    [_navLabel setTextColor:[UIColor whiteColor]];
    [_navLabel setUserInteractionEnabled:YES];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:_navLabel];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:0];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(2, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = title;
}

-(void)initParams{
    self.WXDNavVC.navigationBar.barTintColor = [UIColor colorWithRed:11/255.0 green:81/255.0 blue:179/255.0 alpha:1.0];
    [self.WXDNavVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

#pragma mark - ------------------Reachability Observer----------------------------
/***/
-(void) reachabilityDidChange:(NSNotification *)notification
{
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        DLog(@"reachable.");
        bReachability = YES;
    } else {
        bReachability = NO;
        [[[UIAlertView alloc] initWithTitle:@"网络状况" message:@"尚未连接网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

#pragma mark SVProgressHUD dismiss
-(void) showHUD
{
    [SVProgressHUD show];
}

-(void) showHUDWithMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];
}

- (void)dismissHUD
{
	[SVProgressHUD dismiss];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
