//
//  ViewController.m
//  DynamicApp
//
//  Created by new_ctrip on 13-6-13.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//
//  Protoshop 主页面控制器
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import "WXDProjectsViewController.h"
#import "WXDNewSettingViewController.h"
#import "WXDProjectTableViewCell.h"
#import "WXDMainTableView.h"
#import "WXDRequestCommand.h"

/** model*/
#import "WXDProjectInfo.h"


/** 第三方API*/
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "DAProgressOverlayView.h"

@interface WXDProjectsViewController ()<WXDMainTableViewDelegate, UIAlertViewDelegate>
/**
 *  合并服务器工程列表和本地缓存列表
 */
-(void) mergeOnlineIntoLocation:(NSMutableArray *) onlineProjectsInfoList;

/**
 * 加载网络数据
 */
-(void) loadDataFromOnline;

/**
 * 加载本地缓存数据
 */
-(void) loadDataFromLocation;

/**
 * the observer of project list changed
 */
-(void) projectListChanged:(NSNotification *) notification;

/**
 * the observer for recieving the notification of reloading tablecell
 */
-(void) reloadTableCell:(NSNotification *) notification;

/**
 * The observer for recieving the notification of clear cache
 */
-(void) clearCache:(NSNotification *) notification;

@property (strong, nonatomic) IBOutlet UISearchBar *projectSearchBar;
@property (strong, nonatomic) IBOutlet WXDMainTableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (strong, nonatomic) NSMutableArray *projectInfoList; //当前工程列表列表
@property (strong, nonatomic) NSMutableArray *searchedProjectInfoList; //搜索以后符合条件的列表表单
@property (assign, nonatomic) BOOL beClearCache; //清理缓存需要刷新

@end

@implementation WXDProjectsViewController
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
    
    if (_beClearCache == YES) {
        [self loadDataFromOnline];
        _beClearCache = NO;
    }
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WXDMainTableView class];
    
    _projectInfoList = [[NSMutableArray alloc] init];
    _searchedProjectInfoList = [[NSMutableArray alloc] init];
    
    _mainTableView.MTVDelegate = self;
    [_mainTableView setInitParamsWith:_mainTableView.frame style:UITableViewStylePlain];
    SET_FONT(_refreshBtn.titleLabel,@"FontAwesome",24.0);
    SET_FONT(_settingBtn.titleLabel,@"FontAwesome",24.0);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignSearchBar:)];
    [_topTitleView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectListChanged:) name:__Protoshop_Project_State_Changed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableCell:) name:__Protoshop_Reload_TableCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache:) name:__Protoshop_Clear_Cache object:nil];
    
    _beClearCache = NO;
    [self loadDataFromLocation];
    [self loadDataFromOnline];
}

-(void)resignSearchBar:(UITapGestureRecognizer *)gesture{
    if ([_projectSearchBar isFirstResponder]==YES) {
        [_projectSearchBar resignFirstResponder];
        if ([_projectSearchBar.text isEqualToString:@""]==YES) {
            [_searchedProjectInfoList removeAllObjects];
            [_mainTableView reloadData];
        }
        return;
    }
}

#pragma mark - --------------------System--------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - --------------------功能函数--------------------

-(void) loadDataFromOnline
{
    if (bReachability == NO) {
        [self loadDataFromLocation];
    } else {
        [self showHUD];
        WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
        [requestCommand command_fetch_projects_list:@"ios"
                                              token:[USER_DEFAULT objectForKey:@"userToken"]
                                            success:^(NSMutableArray *projectsarr) {
                                                [self mergeOnlineIntoLocation:projectsarr];
                                                [_mainTableView reloadData];
                                                [self dismissHUD];
                                            } failure:^(NSError *error) {
                                                [self dismissHUD];
                                                SHOW_ALERT(@"获取工程列表失败",[error localizedDescription]);
                                            }];
    }

}

-(void) loadDataFromLocation
{
    NSData *decodedObject = [USER_DEFAULT objectForKey:[NSString stringWithFormat:__Protoshop_Project_List,[USER_DEFAULT objectForKey:@"userEmail"]]];
    if (decodedObject == nil) {
        return;
    }
    
    _projectInfoList = [NSKeyedUnarchiver unarchiveObjectWithData: decodedObject];
}

-(void) mergeOnlineIntoLocation:(NSMutableArray *) onlineProjectsInfoList
{
    if ([_projectInfoList count] == 0) {
        _projectInfoList = [[NSMutableArray alloc] initWithArray:onlineProjectsInfoList copyItems:YES];
    } else {
        for (NSUInteger i = 0; i < [onlineProjectsInfoList count]; i++) {
            WXDProjectInfo *onlineItem = [onlineProjectsInfoList objectAtIndex:i];
            for (NSUInteger j = 0; j < [_projectInfoList count]; j++) {
                WXDProjectInfo *localItem = [_projectInfoList objectAtIndex:j];
                if ([onlineItem.appID isEqualToString:localItem.appID] == YES) {
                    if (localItem.bDownload == YES &&
                        [onlineItem.editTime isEqualToString:localItem.editTime]) {
                        onlineItem.bDownload = YES;
                        onlineItem.appPath = [localItem.appPath copy];
                    } else {
                        onlineItem.bDownload = NO;
                    }
                }
            }
        }
        
        [_projectInfoList removeAllObjects];
        _projectInfoList = nil;
        _projectInfoList = [[NSMutableArray alloc] initWithArray:onlineProjectsInfoList copyItems:YES];
    }
    
    NSData *encodeObject = [NSKeyedArchiver archivedDataWithRootObject:_projectInfoList];
    [USER_DEFAULT setObject:encodeObject forKey:[NSString stringWithFormat:__Protoshop_Project_List,[USER_DEFAULT objectForKey:@"userEmail"]]];
    [USER_DEFAULT synchronize];

}


-(void) projectListChanged:(NSNotification *)notification
{
    NSData *encodeObject = [NSKeyedArchiver archivedDataWithRootObject:_projectInfoList];
    [USER_DEFAULT setObject:encodeObject forKey:[NSString stringWithFormat:__Protoshop_Project_List,[USER_DEFAULT objectForKey:@"userEmail"]]];
    [USER_DEFAULT synchronize];
}

-(void) reloadTableCell:(NSNotification *)notification
{
    NSString *appID = (NSString *)[notification object];
    NSUInteger index = -1;
    
    if (_searchedProjectInfoList != nil && [_searchedProjectInfoList count] > 0) {
        for (int i = 0; i < [_searchedProjectInfoList count]; i++) {
            WXDProjectInfo *projectInfo = (WXDProjectInfo *)[_searchedProjectInfoList objectAtIndex:i];
            if ([appID isEqualToString:projectInfo.appID]) {
                index = i;
                break;
            }
        }

    } else {
        for (int i = 0; i < [_projectInfoList count]; i++) {
            WXDProjectInfo *projectInfo = (WXDProjectInfo *)[_projectInfoList objectAtIndex:i];
            if ([appID isEqualToString:projectInfo.appID]) {
                index = i;
                break;
            }
        }
    
    }
    
    if (index != -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

-(void) clearCache:(NSNotification *) notification
{
    for (int i = 0; i < [_projectInfoList count]; i++) {
        WXDProjectInfo *projectInfo = [_projectInfoList objectAtIndex:i];
        projectInfo.bDownload = NO;
        projectInfo.appPath = @"";
    }
    [_mainTableView reloadData];
}

#pragma mark - --------------------按钮事件--------------------
- (IBAction)refreshClickOn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:__Protoshop_Cancle_Download object:nil];
    [self loadDataFromOnline];
}

- (IBAction)goSetting:(id)sender {
    WXDNewSettingViewController *settingVC = [[WXDNewSettingViewController alloc]initWithNavTitle:@"Setting"];
    settingVC.WXDNavVC = self.navigationController;
    [settingVC initParams];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - --------------------代理方法--------------------
#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //TODO
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"appName", searchText];
    _searchedProjectInfoList = [NSMutableArray arrayWithArray:[_projectInfoList filteredArrayUsingPredicate:predicateString]];
    if ([_searchedProjectInfoList count] > 0) {
        [self.mainTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""] == YES) {
        [_searchedProjectInfoList removeAllObjects];
        _searchedProjectInfoList = nil;
        [self.mainTableView reloadData];
    }
}

#pragma mark - WXDMainTableViewDelegate
- (void)WXDMainTableViewDidStartRefreshing:(WXDMainTableView *)tableView{
    [self loadDataFromOnline];
}

- (NSDate *)WXDMainTableViewRefreshingFinishedDate{
    NSDate *now = [NSDate date];
    return now;
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.mainTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.mainTableView tableViewDidEndDragging:scrollView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger ret = 0;
    if (_searchedProjectInfoList != nil && [_searchedProjectInfoList count] != 0) {
        ret = [_searchedProjectInfoList count];
    } else {
        if (_projectInfoList != nil) {
            ret = [_projectInfoList count];
        }
    }
    DLog(@"table number: %d", ret);
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WXDProjectTableViewCell";
    WXDProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WXDProjectTableViewCell" owner:self options:nil];
        cell = (WXDProjectTableViewCell *)[nibArray objectAtIndex:0];
    }
    WXDProjectInfo *projectInfo = nil;
    
    if (_searchedProjectInfoList == nil || [_searchedProjectInfoList count] < 1) {
        if (_projectInfoList != nil && [_projectInfoList count] != 0) {
            projectInfo = (WXDProjectInfo *)[_projectInfoList objectAtIndex:indexPath.row];
            cell.projectInfo = projectInfo;
        }
    } else {
        projectInfo = (WXDProjectInfo *)[_searchedProjectInfoList objectAtIndex:indexPath.row];
        cell.projectInfo = projectInfo;
    }
    
    if (projectInfo != nil) {
        [cell.projectNameLabel setText:projectInfo.appName];
        [cell.projectCommentLabel setText:projectInfo.appDesc];
        cell.projectIconImageView.image = [UIImage imageNamed:@"icon-120.png"];
        if (projectInfo.bDownload == YES) {
            cell.blueDotImageView.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_projectSearchBar isFirstResponder]==YES) {
        [_projectSearchBar resignFirstResponder];
    }

    
    WXDProjectTableViewCell *cell = (WXDProjectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        [cell downloadProjectPackage];
    }
    
}

@end