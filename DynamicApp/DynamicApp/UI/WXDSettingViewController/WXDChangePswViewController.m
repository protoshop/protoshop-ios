//
//  WXDChangePswViewController.m
//  Protoshop
//
//  Created by HongliYu on 14-2-17.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 密码修改页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月14日

#import "WXDChangePswViewController.h"
#import "SVProgressHUD.h"

@interface WXDChangePswViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *changePswView;
@property (strong, nonatomic) IBOutlet UITextField *currentPswTF;
@property (strong, nonatomic) IBOutlet UITextField *theNewPswTF;
@property (strong, nonatomic) IBOutlet UITextField *retpyePswTF;
@end

@implementation WXDChangePswViewController
#pragma mark - --------------------初始化--------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToSettingView:)];
    [self.navLabel addGestureRecognizer:tapOnLabel];
    
    _changePswView.layer.cornerRadius = 2.0;
    _changePswView.layer.borderWidth = 0.2;
    
    _currentPswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _currentPswTF.leftView.userInteractionEnabled = NO;
    _currentPswTF.leftViewMode = UITextFieldViewModeAlways;
    
    _theNewPswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _theNewPswTF.leftView.userInteractionEnabled = NO;
    _theNewPswTF.leftViewMode = UITextFieldViewModeAlways;
    
    _retpyePswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 0)];
    _retpyePswTF.leftView.userInteractionEnabled = NO;
    _retpyePswTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.0, 280.0, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 88.0, 280.0, 0.5)];
    [lineView2 setBackgroundColor:[UIColor grayColor]];
    
    [_changePswView addSubview:lineView];
    [_changePswView addSubview:lineView2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePswResignTFAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

#pragma mark - --------------------按钮事件--------------------
-(void)changePsw
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    WXDRequestCommand *command = [WXDRequestCommand sharedWXDRequestCommand];
    [command command_update_password:_theNewPswTF.text
                         oldPassword:_currentPswTF.text
                      retypePassword:_retpyePswTF.text
                               token:[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"]
                             success:^(NSInteger state) {
                                 [SVProgressHUD dismiss];
                                 SHOW_ALERT(@"修改成功",@"密码修改成功");
                             } failure:^(NSError *error) {
                                 [SVProgressHUD dismiss];
                                 if (error != nil) {
                                     SHOW_ALERT(@"提示信息",(NSString *)[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                                 }
                             }];
}

-(void)backToSettingView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------------手势事件--------------------
- (void)changePswResignTFAction:(UITapGestureRecognizer *)tapGesture{
    [_currentPswTF resignFirstResponder];
    [_theNewPswTF resignFirstResponder];
    [_retpyePswTF resignFirstResponder];
}

#pragma mark - --------------------代理方法--------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _currentPswTF) {
        [textField resignFirstResponder];
        [_theNewPswTF becomeFirstResponder];
    }
    if (textField == _theNewPswTF) {
        [textField resignFirstResponder];
        [_retpyePswTF becomeFirstResponder];

    }
    if (textField == _retpyePswTF) {
        [self changePsw];
    }
    return YES;
}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
