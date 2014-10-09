//
//  WXDLoginViewController.m
//  ToHell2iOS
//
//  Created by HongliYu on 14-1-15.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 登录页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import "WXDLoginViewController.h"
#import "WXDProjectsViewController.h"
#import "WXDSignupViewController.h"
#import "WXDUserInfo.h"
#import "CTAuthEngine.h"
#import "WXDRequestCommand.h"
#import "SVProgressHUD.h"

@interface WXDLoginViewController ()<UITextFieldDelegate,CTSSOAuthDelegate>
@property (strong, nonatomic) IBOutlet UIButton *SSOLoginBtn;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *signupBtn;
@property (strong, nonatomic) IBOutlet UITextField *userEmailTF;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTF;
@end

@implementation WXDLoginViewController
#pragma mark - --------------------初始化--------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([USER_DEFAULT objectForKey:@"userEmail"]!=nil && [USER_DEFAULT objectForKey:@"userToken"]!=nil) {
//        WXDProjectsViewController *mainViewController = [[WXDProjectsViewController alloc]init];
//        [self.navigationController pushViewController:mainViewController animated:YES];
//    }
    if (isSSOLoginHidden == YES) {
        [_SSOLoginBtn setHidden:YES];
    }
    self.loginView.layer.cornerRadius = 2.0;
    
    _userEmailTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _userEmailTF.leftView.userInteractionEnabled = NO;
    _userEmailTF.leftViewMode = UITextFieldViewModeAlways;
    _userEmailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _userPasswordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _userPasswordTF.leftView.userInteractionEnabled = NO;
    _userPasswordTF.leftViewMode = UITextFieldViewModeAlways;
    _userPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //ib设置必须是整数
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, 280.0, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    
    [self.loginView addSubview:lineView];
    
    self.loginBtn.layer.cornerRadius = 2.0;
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.signupBtn addTarget:self action:@selector(goSignupPageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginResignTFAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - --------------------按钮事件--------------------
- (void)goSignupPageAction:(id)sender{
    WXDSignupViewController *signupVC = [[WXDSignupViewController alloc]initWithNavTitle:@"Sign Up"];
    signupVC.WXDNavVC = self.navigationController;
    [signupVC initParams];
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (void)loginAction:(id)sender {
    [SVProgressHUD showWithStatus:@"请稍后..."];
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_login:_userEmailTF.text
                         password:_userPasswordTF.text
                          success:^(WXDUserInfo *userInfo) {
                              [SVProgressHUD dismiss];
                              [USER_DEFAULT setObject:userInfo.email forKey:@"userEmail"];
                              [USER_DEFAULT setObject:userInfo.name forKey:@"userName"];
                              [USER_DEFAULT setObject:userInfo.token forKey:@"userToken"];
                              [USER_DEFAULT setObject:userInfo.nickname forKey:@"userNickname"];
                              [USER_DEFAULT synchronize];
                              [SVProgressHUD dismiss];
                              
                              WXDProjectsViewController *mainVC = [[WXDProjectsViewController alloc]init];
                              if ([((UINavigationController *)(self.view.window.rootViewController)).viewControllers[0] isKindOfClass:[WXDLoginViewController class]]) {
                                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
                                self.view.window.rootViewController = nav;
                              }
                             [self.navigationController popToRootViewControllerAnimated:YES];

                          }
                          failure:^(NSError *error) {
                              [SVProgressHUD dismiss];
                              [self lockAnimationForView:self.loginView];
                          }];
}

- (IBAction)doSSOLogin:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [CTAuthEngine startSSOAuth:self withType:eAuthTypePush];
}

#pragma mark - --------------------手势事件--------------------
- (void)loginResignTFAction:(UITapGestureRecognizer *)tapGesture{
    [_userPasswordTF resignFirstResponder];
    [_userEmailTF resignFirstResponder];
}

#pragma mark - --------------------功能函数--------------------
- (void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - --------------------代理方法--------------------
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_userEmailTF isFirstResponder]==YES) {
        [_userEmailTF resignFirstResponder];
        [_userPasswordTF becomeFirstResponder];
    }else{
        [self loginAction:self];
    }
    return YES;
}

#pragma mark CTSSOAuthDelegate
- (void)authSuccess:(NSDictionary *)userInfo
{
    WXDUserResultInfo *resultInfo = [[WXDUserResultInfo alloc] initWithJsonObject:userInfo];
    WXDResultStateInfo *resultState = [resultInfo resultState];
    NSInteger resultInfoState = resultState.state;
    if (resultInfoState == 0) {
        WXDUserInfo *userInfo = (WXDUserInfo *)[[resultInfo userResultInfoList] objectAtIndex:0];
        [USER_DEFAULT setObject:userInfo.email forKey:@"userEmail"];
        [USER_DEFAULT setObject:userInfo.name forKey:@"userName"];
        [USER_DEFAULT setObject:userInfo.token forKey:@"userToken"];
        [USER_DEFAULT setObject:userInfo.nickname forKey:@"userNickname"];
        [USER_DEFAULT synchronize];
        WXDProjectsViewController *mainVC = [[WXDProjectsViewController alloc]init];
        [self.navigationController pushViewController:mainVC animated:NO];
    } else {
        SHOW_ALERT(@"SSO登录出错",(NSString*)userInfo);
    }
    
}
@end