//
//  WXDNewSettingViewController.m
//  Protoshop
//
//  Created by Anselz on 14-7-22.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "WXDNewSettingViewController.h"
#import "WXDSettingTableViewCell.h"
#import "UIApplication+SSAppURLs.h"
#import "WXDChangePswViewController.h"
#import "FeedBackTableViewCell.h"

@interface WXDNewSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isShowFeedBack;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WXDNewSettingViewController



#pragma mark - --------------------退出清空--------------------

#pragma mark - --------------------初始化--------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initBaseData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initBaseData
{
    _isShowFeedBack = NO;
}

-(void)initBaseView
{
    self.title = @"Setting";
    UITapGestureRecognizer *tapOnLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backMainVC:)];
    [self.navLabel addGestureRecognizer:tapOnLabel];
}

#pragma mark - --------------------System--------------------

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - --------------------功能函数--------------------

-(void)gotoDonate
{
    SSAppURLType type = SSAppURLTypeSafariHTTPS;
    [[UIApplication sharedApplication] openAppType:type
                                         withValue:@"https://qr.alipay.com/ap27zqsxo3v5q61z1f"];
}

-(void)gotoChangePassword
{
    WXDChangePswViewController *changPswVC = [[WXDChangePswViewController alloc]initWithNavTitle:@"Change Password"];
    changPswVC.WXDNavVC = self.navigationController;
    [changPswVC initParams];
    [self.navigationController pushViewController:changPswVC animated:YES];
    
}

-(void)clearCache
{
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
        }
    }
    
}

-(void)logoutAction
{
    [USER_DEFAULT removeObjectForKey:@"userEmail"];
    [USER_DEFAULT removeObjectForKey:@"userPassword"];
    [USER_DEFAULT removeObjectForKey:@"userNickname"];
    [USER_DEFAULT synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)sendFeedBack:(NSString *)context{
    if (context.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Context is Empyt." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_update_userinfo:[USER_DEFAULT objectForKey:@"userToken"]
                                   username:[USER_DEFAULT objectForKey:@"userName"]
                                   nickname:[USER_DEFAULT objectForKey:@"userNickname"]
                                    success:^(NSInteger state) {
                                    }
                                    failure:^(NSError *error) {
                                        
                                    }];
}



#pragma mark - --------------------手势事件--------------------

-(void)backMainVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------------按钮事件--------------------

#pragma mark - --------------------代理方法--------------------
#pragma TableVeiew & TableViewDataSources Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRow = 0;
    switch (section) {
        case 0:
            numberOfRow = 2;
            break;
        case 1:
            numberOfRow = 1;
            break;
        case 2:
            numberOfRow = 1;
            break;
        case 3:
            numberOfRow = 1;
            break;
        case 4:
            numberOfRow = 1;
            break;
        case 5:
            numberOfRow = 1;
            break;
        default:
            numberOfRow = 0;
            break;
    }
    return numberOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 44.0f;
    if (indexPath.section == 4) {
        if (_isShowFeedBack) {
            heightForRow = 200.0f;
        } else {
            heightForRow = 44.0f;
        }
    }
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0f;
    } else if (section == 1 || section == 2 || section == 5) {
        return 15.0f;
    } else {
        return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        FeedBackTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedBackTableViewCell class])];
        if (cell == nil) {
            cell = (FeedBackTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FeedBackTableViewCell class]) owner:nil options:nil] objectAtIndex:0];
        }
        [cell showFeedBackTextField:^(NSString *context) {
            [self sendFeedBack:context];
        } startEdit:^{
            
            [UIView animateWithDuration:0.1 animations:^{
                self.mainTableView.frame = CGRectMake(0, 0, 320, 360);
                self.mainTableView.contentOffset = CGPointMake(0, 170);
            } completion:^(BOOL finished) {
                
            }];
            
        } endEdit:^{
            [UIView animateWithDuration:0.1 animations:^{
                self.mainTableView.frame = CGRectMake(0, 0, 320, 568);
            } completion:^(BOOL finished) {
                _isShowFeedBack = NO;
                [tableView reloadData];
            }];
            
        }];
        cell.iconLabel.text =@"";
        cell.titleLabel.text = @"Feedback";
        if (_isShowFeedBack) {
            cell.arrowLabel.text = @"";
        } else {
            cell.arrowLabel.text = @"";
        }
        return cell;
    }
    
    WXDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXDSettingTableViewCell class])];
    if (cell == nil) {
        cell = (WXDSettingTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXDSettingTableViewCell class]) owner:nil options:nil] objectAtIndex:0];
    }
    NSString *title = @"";
    NSString *icon = @"";
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                title = [USER_DEFAULT objectForKey:@"userEmail"];
                icon = @"";
            } else {
                title = [USER_DEFAULT objectForKey:@"userNickname"];
                icon = @"";
            }
            cell.arrowLabel.hidden = YES;
        }
            
            break;
        case 1:
        {
            cell.arrowLabel.hidden = NO;
            title = @"Change Password";
            icon = @"";
        }
            
            break;
        case 2:
            cell.arrowLabel.hidden = YES;
            title = @"Clear Cache";
            icon = @"";
            
            break;
        case 3:
        {
            cell.arrowLabel.hidden = NO;
            title = @"Donate";
            icon = @"";
        }
            break;
        case 5:
        {
            cell.arrowLabel.hidden = YES;
            title = @"Logout";
            icon = @"";
        }
            break;
            
        default:
            break;
    }
    cell.titleLabel.text = title;
    cell.iconLabel.text = icon;
    if (indexPath.section == 4) {
        
    }
    if (indexPath.section ==3 || indexPath.section == 2 ||indexPath.section == 5 ||indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self gotoChangePassword];
    }
    if (indexPath.section == 2) {
        WXDSettingTableViewCell *cell = (WXDSettingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showConfirmButton:eTableViewCellActionTypeClear withAction:^{
            [self clearCache];
        }];
    }
    if (indexPath.section == 3) {
        [self gotoDonate];
    }
    if (indexPath.section == 4) {
        _isShowFeedBack = !_isShowFeedBack;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section == 5) {
        WXDSettingTableViewCell *cell = (WXDSettingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showConfirmButton:eTableViewCellActionTypeLogout withAction:^{
            [self logoutAction];
        }];
    }
    
}

#pragma mark - --------------------属性相关--------------------

#pragma mark - --------------------接口API--------------------

@end
