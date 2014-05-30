//
//  signUpVC.m
//  Protoshop
//
//  Created by HongliYu on 14-1-20.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 注册页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import "WXDSignupViewController.h"
#import "WXDProjectsViewController.h"

@interface WXDSignupViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTF;
@property (strong, nonatomic) IBOutlet UIView *signupView;
@property (strong, nonatomic) IBOutlet UIButton *signupBtn;
@end

@implementation WXDSignupViewController
#pragma mark - --------------------初始化--------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToLogin:)];
    [self.navLabel addGestureRecognizer:tapOnLabel];
    
    _signupView.layer.cornerRadius = 2.0;
    _signupView.layer.borderWidth = 0.2;
    
    _emailAddressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _emailAddressTF.leftView.userInteractionEnabled = NO;
    _emailAddressTF.leftViewMode = UITextFieldViewModeAlways;
    
    _userPasswordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _userPasswordTF.leftView.userInteractionEnabled = NO;
    _userPasswordTF.leftViewMode = UITextFieldViewModeAlways;
    
    //ib设置必须是整数
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, 280.0, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [_signupView addSubview:lineView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signupResignTFAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.signupBtn.layer.cornerRadius = 2.0;
    [self.signupBtn addTarget:self action:@selector(signupAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - --------------------手势事件--------------------
-(void)signupResignTFAction:(UITapGestureRecognizer *)tapGesture{
    [_userPasswordTF resignFirstResponder];
    [_emailAddressTF resignFirstResponder];
}

#pragma mark - --------------------按钮事件--------------------
-(void)backToLogin:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)signupAction:(id)sender{
    WXDRequestCommand *command = [WXDRequestCommand sharedWXDRequestCommand];
    [command command_register:_emailAddressTF.text
                     password:_userPasswordTF.text
                     nickName:@""
                      success:^(WXDUserInfo *userInfo) {
                          [USER_DEFAULT setObject:userInfo.name forKey:@"userEmail"];
                          [USER_DEFAULT setObject:userInfo.token forKey:@"userToken"];
                          [USER_DEFAULT synchronize];
                          WXDProjectsViewController *mainVC = [[WXDProjectsViewController alloc]init];
                          [self.navigationController pushViewController:mainVC animated:NO];
                      }
                      failure:^(NSError *error) {
                          if (error != nil) {
                              SHOW_ALERT(@"提示信息",(NSString *)[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                          }
                      }];

}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end