//
//  WXDSettingViewController.m
//  Protoshop
//
//  Created by HongliYu on 14-1-24.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//
//  Protoshop 设置页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月14日

#import "WXDSettingViewController.h"
#import "WXDProjectInfo.h"
#import "WXDChangePswViewController.h"
#import "CTAuthEngine.h"
#import "WXDProjectsViewController.h"
#import <UIApplication+SSAppURLs.h>

#define ExpandScale 150.0
#define LargestNum 240
#define StandardFontSize 24.0
#define ClearCacheInterval 0.4
#define FeedBackShowInterval 0.6
#define FeedBackHideInterval 0.4

@interface WXDSettingViewController ()<UITextViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *accountView;
@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *userEmailContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userNicknameContent;
@property (strong, nonatomic) IBOutlet UIButton *cacheConfirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *logoutConfirmBtn;

@property (strong, nonatomic) IBOutlet UILabel *pswIcon;
@property (strong, nonatomic) IBOutlet UILabel *pswContent;
@property (strong, nonatomic) IBOutlet UILabel *pswArrow;
@property (strong, nonatomic) IBOutlet UILabel *cacheIcon;
@property (strong, nonatomic) IBOutlet UILabel *cacheContent;
@property (strong, nonatomic) IBOutlet UIView *cacheView;
@property (strong, nonatomic) IBOutlet UIView *feedBackView;
@property (strong, nonatomic) IBOutlet UILabel *feedBackContent;
@property (strong, nonatomic) IBOutlet UILabel *logOutIcon;
@property (strong, nonatomic) IBOutlet UILabel *logOutContent;
@property (strong, nonatomic) IBOutlet UILabel *feedBackIcon;
@property (strong, nonatomic) IBOutlet UIView *logOutView;
@property (strong, nonatomic) IBOutlet UILabel *feedBackArrow;
@property (strong, nonatomic) IBOutlet UIView *donateView;
@property (strong, nonatomic) IBOutlet UILabel *donateContent;
@property (strong, nonatomic) IBOutlet UILabel *donateArrow;
@property (strong, nonatomic) IBOutlet UILabel *donateIcon;

@end

@implementation WXDSettingViewController
{
    UITextView *feedBackTextView;
    UILabel *statusLabel;
    UIButton *sendMsg;
    BOOL isWritingFeedBack;
    BOOL isFeedBackViewExpanded;
}

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
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SET_FONT(_userEmailLabel,@"FontAwesome",StandardFontSize);
    SET_FONT(_userNameLabel,@"FontAwesome",StandardFontSize);
    SET_FONT(_pswIcon,@"FontAwesome",StandardFontSize);
    SET_FONT(_pswArrow,@"FontAwesome",StandardFontSize);
    SET_FONT(_cacheIcon,@"FontAwesome",StandardFontSize);
    SET_FONT(_feedBackIcon,@"FontAwesome",StandardFontSize);
    SET_FONT(_logOutIcon,@"FontAwesome",StandardFontSize);
    SET_FONT(_feedBackArrow,@"FontAwesome",StandardFontSize);
    SET_FONT(_donateIcon,@"FontAwesome",StandardFontSize);
    SET_FONT(_donateArrow,@"FontAwesome",StandardFontSize);
    
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backMainVC:)];
    [self.navLabel addGestureRecognizer:tapOnLabel];
    
    UITapGestureRecognizer *tapPsw = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnPsw:)];
    [_pswContent addGestureRecognizer:tapPsw];
    
    UITapGestureRecognizer *tapFeedBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnFeedBack:)];
    [_feedBackContent addGestureRecognizer:tapFeedBack];
    
    UITapGestureRecognizer *tapLogOut = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnLogout:)];
    [_logOutContent addGestureRecognizer:tapLogOut];
    
    UITapGestureRecognizer *tapClearCache = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnClearCache:)];
    [_cacheContent addGestureRecognizer:tapClearCache];
    
    UITapGestureRecognizer *tapOnAccountView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnAccountView:)];
    [self.accountView addGestureRecognizer:tapOnAccountView];
    
    UITapGestureRecognizer *tapOnMainView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnMainView:)];
    [self.view addGestureRecognizer:tapOnMainView];
    
    UITapGestureRecognizer *tapOnDonateView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnceOnDonateView:)];
    [self.donateView addGestureRecognizer:tapOnDonateView];
    
    self.logoutConfirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.logoutConfirmBtn addTarget:self action:@selector(pressOnLogoutConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cacheConfirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.cacheConfirmBtn addTarget:self action:@selector(pressOnCacheConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cacheContent setUserInteractionEnabled:NO];
    self.cacheContent.alpha = 0.4;
    [self checkCache];

    /**
     *  FeedBack容器相关
     */
    feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 44.0, 300.0, ExpandScale-30.0)];
    feedBackTextView.layer.borderWidth = 0.4;
    feedBackTextView.scrollEnabled = YES;
    feedBackTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    feedBackTextView.text = @"请留下您宝贵的意见和建议";
    [feedBackTextView setTextColor:[UIColor grayColor]];
    [feedBackTextView setBackgroundColor:[UIColor clearColor]];
    feedBackTextView.delegate = self;
    
    sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMsg.backgroundColor = [UIColor clearColor];
    sendMsg.alpha = 0.4;
    [sendMsg setUserInteractionEnabled:NO];
    
    sendMsg.frame = CGRectMake(250.0, 164.0, 60.0, 30.0);
    [sendMsg setTitleColor:[UIColor colorWithRed:253/255.0 green:138/255.0 blue:37/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendMsg setTitle:@"Send" forState:UIControlStateNormal];
    [sendMsg addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(220.0,164.0, 60.0, 30.0)];
    [statusLabel setText:[NSString stringWithFormat:@"%d",LargestNum]];
    [statusLabel setTextColor:[UIColor grayColor]];
    
    _userEmailContentLabel.text = [USER_DEFAULT objectForKey:@"userEmail"];
    self.userNicknameContent.text = [USER_DEFAULT objectForKey:@"userNickname"];
    
    isWritingFeedBack = NO;
}

#pragma mark - --------------------手势事件--------------------
-(void)tapOnceOnDonateView:(UIGestureRecognizer*)gesture{
    SSAppURLType type = SSAppURLTypeSafariHTTPS;
    [[UIApplication sharedApplication] openAppType:type
                                         withValue:@"https://qr.alipay.com/ap27zqsxo3v5q61z1f"];
}

-(void)tapOnceOnMainView:(UIGestureRecognizer*)gesture{
    [self.userNicknameContent resignFirstResponder];
}

-(void)tapOnceOnAccountView:(UITapGestureRecognizer *)gesture{
    if (isWritingFeedBack == YES) {
        [self restoreFeedBack];
    }
}

-(void)tapOnceOnFeedBack:(UITapGestureRecognizer *)gesture{
    if (isWritingFeedBack == NO) {
        _feedBackArrow.text =  @"";
        [UIView animateWithDuration:FeedBackShowInterval animations:^{
            self.feedBackView.frame = CGRectMake(self.feedBackView.frame.origin.x, self.feedBackView.frame.origin.y,
                                                 self.feedBackView.frame.size.width, self.feedBackView.frame.size.height +ExpandScale);
            _logOutView.center = CGPointMake(_logOutView.center.x, _logOutView.center.y + ExpandScale);
        } completion:^(BOOL finished) {
            [self.feedBackView addSubview:feedBackTextView];
            [self.feedBackView addSubview:sendMsg];
            [self.feedBackView addSubview:statusLabel];
            isWritingFeedBack = YES;
            sendMsg.alpha = 0.4;
            [sendMsg setUserInteractionEnabled:NO];
            isFeedBackViewExpanded = YES;
        }];
    }else if([feedBackTextView isFirstResponder]== NO){
        [feedBackTextView removeFromSuperview];
        [sendMsg removeFromSuperview];
        [statusLabel removeFromSuperview];
        _feedBackArrow.text =  @"";
        [UIView animateWithDuration:FeedBackShowInterval animations:^{
            self.feedBackView.frame = CGRectMake(self.feedBackView.frame.origin.x, self.feedBackView.frame.origin.y,
                                                 self.feedBackView.frame.size.width, self.feedBackView.frame.size.height -ExpandScale);
            _logOutView.center = CGPointMake(_logOutView.center.x, _logOutView.center.y - ExpandScale);
        } completion:^(BOOL finished) {
            isWritingFeedBack = NO;
            sendMsg.alpha = 0.4;
            [sendMsg setUserInteractionEnabled:NO];
            isFeedBackViewExpanded = NO;
        }];
    }else{
        [self restoreFeedBack];
    }
    
}

-(void)tapOnceOnPsw:(UITapGestureRecognizer *)gesture{
    if (isFeedBackViewExpanded == YES) {
        [self tapOnceOnFeedBack:nil];
    }
    WXDChangePswViewController *changPswVC = [[WXDChangePswViewController alloc]initWithNavTitle:@"Change Password"];
    changPswVC.WXDNavVC = self.navigationController;
    [changPswVC initParams];
    [self.navigationController pushViewController:changPswVC animated:YES];
}

-(void)tapOnceOnLogout:(UITapGestureRecognizer *)gesture{
    if (self.logoutConfirmBtn.alpha == 1.0) {
        [UIView animateWithDuration:0.4 animations:^{
            _logoutConfirmBtn.center = CGPointMake(360.0, _logoutConfirmBtn.center.y);
            _logoutConfirmBtn.alpha = 0.8;
        }completion:^(BOOL finished) {
            ;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            _logoutConfirmBtn.center = CGPointMake(280.0, _logoutConfirmBtn.center.y);
            _logoutConfirmBtn.alpha = 1.0;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

-(void)tapOnceOnClearCache:(UITapGestureRecognizer *)gesture{
    if (self.cacheConfirmBtn.alpha == 1.0) {
        [UIView animateWithDuration:ClearCacheInterval animations:^{
            _cacheConfirmBtn.center = CGPointMake(360.0, _cacheConfirmBtn.center.y);
            _cacheConfirmBtn.alpha = 0.8;
        } completion:^(BOOL finished) {
            ;
        }];
    }else{
        [UIView animateWithDuration:ClearCacheInterval animations:^{
            _cacheConfirmBtn.center = CGPointMake(280.0, _cacheConfirmBtn.center.y);
            _cacheConfirmBtn.alpha = 1.0;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

#pragma mark - --------------------按钮事件--------------------

-(void)backMainVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pressOnCacheConfirmBtn:(id)sender{
    self.cacheConfirmBtn.alpha = 0;
    _cacheConfirmBtn.center = CGPointMake(SCREEN_WIDTH, _cacheConfirmBtn.center.y);
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(280.0, 0, 44.0, 44.0);
    [activityView startAnimating];
    [self.cacheView addSubview:activityView];
    [self clearCacheNow];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    UIImageView *tempImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checked.png"]];
    tempImageView.alpha = 0;
    tempImageView.frame = CGRectMake(280.0, 7.0, 30.0, 30.0);
    [self.cacheView addSubview:tempImageView];
    [UIView animateWithDuration:ClearCacheInterval animations:^{
        tempImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
        [self.cacheContent setUserInteractionEnabled:NO];
        self.cacheContent.alpha = 0.4;
    }];
}

-(void)pressOnLogoutConfirmBtn:(id)sender{
    BACK(^{
         [USER_DEFAULT setObject:nil forKey:@"userEmail"];
         [USER_DEFAULT setObject:nil forKey:@"userPassword"];
         [USER_DEFAULT setObject:nil forKey:@"userNickname"];
         [USER_DEFAULT synchronize];
         if ([WXDreach isReachable]==YES) {
             if ([CTAuthEngine logout]) {
                 DLog(@"Logout Success.");
             }
         }
            MAIN(^{[self.navigationController popToRootViewControllerAnimated:YES];});
        });
}

-(void)nickNameConfirmed{
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_update_userinfo:[USER_DEFAULT objectForKey:@"userToken"]
                                   username:[USER_DEFAULT objectForKey:@"userName"]
                                   nickname:self.userNicknameContent.text
                                    success:^(NSInteger state) {
                                        [self.userNicknameContent resignFirstResponder];
                                        [USER_DEFAULT setObject:self.userNicknameContent.text forKey:@"userNickname"];
                                        [USER_DEFAULT synchronize];
                                    }
                                    failure:^(NSError *error) {
                                        SHOW_ALERT(@"更新用户信息错误", [error localizedDescription]);
                                    }];
}

-(void)sendMsg:(id)sender{
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_send_feedback:[USER_DEFAULT objectForKey:@"userToken"]
                                    email:[USER_DEFAULT objectForKey:@"userEmail"]
                                  content:feedBackTextView.text
                                  success:^(NSInteger state) {
                                      SHOW_ALERT(@"提交成功",@"感谢您的反馈");
                                  } failure:^(NSError *error) {
                                      SHOW_ALERT(@"feedback错误",[error localizedDescription]);
                                  }];
    [self restoreFeedBack];
}

#pragma mark - --------------------功能函数--------------------
-(void)clearCacheNow{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userDocDir =[documentsDirectory stringByAppendingPathComponent:[USER_DEFAULT objectForKey:@"userEmail"]];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:userDocDir error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[userDocDir stringByAppendingPathComponent:filename] error:NULL];
    }
    [USER_DEFAULT setObject:nil forKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
    [USER_DEFAULT synchronize];
    for (UIViewController *tempVC in [self.navigationController viewControllers]) {
        NSRange subRange = [tempVC.description rangeOfString:@"WXDProjectsViewController"];
        if (subRange.location != NSNotFound) {
          WXDProjectsViewController *mainVC = (WXDProjectsViewController*)tempVC;
            mainVC.clearCacheNeedRefresh = YES;
        }
    }
}

-(void)checkCache{
    NSData *decodedObject = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
    NSArray *theLastListInfo = [NSKeyedUnarchiver unarchiveObjectWithData: decodedObject];
    for (WXDProjectInfo *lastInfoCell in theLastListInfo) {
        if (lastInfoCell.hasDL ==YES) {
            [self.cacheContent setUserInteractionEnabled:YES];
            self.cacheContent.alpha = 1.0;
        }
    }
}

-(void)restoreFeedBack{
    [self.userNicknameContent setUserInteractionEnabled:YES];
    [feedBackTextView removeFromSuperview];
    [sendMsg removeFromSuperview];
    [statusLabel removeFromSuperview];
    [UIView animateWithDuration:FeedBackHideInterval animations:^{
        _feedBackView.center = CGPointMake(_feedBackView.center.x, _feedBackView.center.y + ExpandScale -10.0 + 52.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:FeedBackHideInterval animations:^{
            self.feedBackView.frame = CGRectMake(self.feedBackView.frame.origin.x, self.feedBackView.frame.origin.y,
                                                 self.feedBackView.frame.size.width, self.feedBackView.frame.size.height - ExpandScale);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:FeedBackHideInterval/2.0 animations:^{
                _logOutView.center = CGPointMake(_logOutView.center.x, _logOutView.center.y - ExpandScale);
            } completion:^(BOOL finished) {
                _feedBackArrow.text =  @"";
                feedBackTextView.text = @"请留下您宝贵的意见和建议";
                [statusLabel setText:[NSString stringWithFormat:@"%d",LargestNum]];
                isWritingFeedBack = NO;
                sendMsg.alpha = 0.4;
                [sendMsg setUserInteractionEnabled:NO];
                isFeedBackViewExpanded = NO;
            }];
        }];
    }];
}

#pragma mark - --------------------代理方法--------------------
#pragma mark ---------textViewDelegate----------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_userNicknameContent setUserInteractionEnabled:NO];
    feedBackTextView.text = @"";
    [UIView animateWithDuration:FeedBackShowInterval animations:^{
        _feedBackView.center = CGPointMake(_feedBackView.center.x, self.feedBackView.center.y - ExpandScale + 10.0 - 52.0);
    } completion:^(BOOL finished) {
        ;
    }];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number > 0) {
        sendMsg.alpha = 1.0;
        [sendMsg setUserInteractionEnabled:YES];
    }else{
        sendMsg.alpha = 0.4;
        [sendMsg setUserInteractionEnabled:NO];
    }
    if (number > LargestNum) {
        textView.text = [textView.text substringToIndex:LargestNum];
        number = LargestNum;
    }
    statusLabel.text = [NSString stringWithFormat:@"%d",LargestNum - number];
}

#pragma mark ---------textFieldDelegate----------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nickNameConfirmed];
    return YES;
}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end