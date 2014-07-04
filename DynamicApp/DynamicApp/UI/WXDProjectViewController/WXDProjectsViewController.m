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
#import "WXDSettingViewController.h"
#import "WXDProjectTableViewCell.h"

/** model*/
#import "WXDProjectInfo.h"
#import "WXDFileKey.h"

/** lua解析器*/
#import "lauxlib.h"
#import "wax.h"

/** wax扩展*/
#import "wax_http.h"
#import "wax_json.h"
#import "wax_xml.h"
#import "wax_CTViewController.h"

/** 第三方API*/
#import "ZipArchive.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "DAProgressOverlayView.h"

@interface WXDProjectsViewController ()<WXDMainTableViewDelegate,UIAlertViewDelegate>
{
    /**
     *  文件信息数组
     */
    NSMutableArray *fileArray;
    /**
     *  当前使用的列表表单
     */
    NSMutableArray *theListInfo;
    /**
     *  缓存最后一次列表表单，比较是增加了，还是减少了，刷新列表时保持与web端同步
     */
    NSMutableArray *theLastListInfo;
    /**
     *  搜索以后符合条件的列表表单
     */
    NSMutableArray *filteredArray;
    DAProgressOverlayView *progressOverlayView;
    NSTimer *downloadTimer;
    NSNumber *theChosenIndex;
}

/**
 *  解压
 */
-(void) refreshList:(id)sender;
/**
 *  更新文件信息数组
 */
-(void) searchDynamicGroup;
@property (strong, nonatomic) IBOutlet UISearchBar *ProtoSearchBar;
@property (strong, nonatomic) IBOutlet WXDMainTableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *topTitleView;
@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
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
    /**
     *  清空搜索结果
     */
    filteredArray = nil;
    if (self.clearCacheNeedRefresh == YES) {
        [self refreshClickOn:self];
        self.clearCacheNeedRefresh = NO;
    }
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WXDMainTableView class];
    
    fileArray = [[NSMutableArray alloc] init];
    
    _mainTableView.MTVDelegate = self;
    [_mainTableView setInitParamsWith:_mainTableView.frame style:UITableViewStylePlain];
    SET_FONT(_refreshBtn.titleLabel,@"FontAwesome",24.0);
    SET_FONT(_settingBtn.titleLabel,@"FontAwesome",24.0);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignSearchBar:)];
    [self.topTitleView addGestureRecognizer:tapGesture];
    
    self.clearCacheNeedRefresh = NO;
    [SVProgressHUD showWithStatus:@"正在刷新列表"];
    [self loadData:@"0"];
}

-(void)resignSearchBar:(UITapGestureRecognizer *)gesture{
    if ([self.ProtoSearchBar isFirstResponder]==YES) {
        [self.ProtoSearchBar resignFirstResponder];
        if ([self.ProtoSearchBar.text isEqualToString:@""]==YES) {
            filteredArray = nil;
            [self.mainTableView reloadData];
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
#pragma mark SVProgressHUD dismiss
- (void)dismiss {
	[SVProgressHUD dismiss];
}

- (void)dismissError {
	[SVProgressHUD showErrorWithStatus:@"刷新失败"];
}

-(BOOL)DownLoadZipFile{
    WXDProjectInfo *infoCell = nil;
    if (filteredArray != nil) {
        infoCell =  filteredArray[[theChosenIndex integerValue]];
    }else{
        infoCell =  theListInfo[[theChosenIndex integerValue]];
    }
    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_create_zip_url:infoCell.appID
                                     token:[USER_DEFAULT objectForKey:@"userToken"]
                                   success:^(NSString *zipPath) {
                                       NSMutableURLRequest *zipDLRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:zipPath]
                                                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                               timeoutInterval:10.0];
                                       AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:zipDLRequest];
                                       operation.outputStream = [NSOutputStream outputStreamToFileAtPath:[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"temp.zip"] append:NO];
                                       [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                           float progress = (float)totalBytesRead /(float)totalBytesExpectedToRead;
                                           progressOverlayView.progress = progress;
                                       }];
                                       [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           DLog(@"download success...");
                                           infoCell.hasDL = YES;
                                           NSData *decodedObject = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
                                           theLastListInfo = [NSKeyedUnarchiver unarchiveObjectWithData: decodedObject];
                                           
                                           WXDProjectInfo *lastInfoCell = theLastListInfo[[theChosenIndex integerValue]];
                                           lastInfoCell.hasDL = YES;
                                           NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:theLastListInfo];
                                           [USER_DEFAULT setObject:encodedObject forKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
                                           [USER_DEFAULT synchronize];
                                           
                                           [self.mainTableView reloadData];
                                           [self refreshList:self];//解压并刷新
                                           [self.mainTableView setUserInteractionEnabled:YES];
                                           
                                           [downloadTimer invalidate];
                                           [progressOverlayView displayOperationDidFinishAnimation];
                                           double delayInSeconds = progressOverlayView.stateChangeAnimationDuration;
                                           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                           dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                               progressOverlayView.progress = 0;
                                               progressOverlayView.hidden = YES;
                                               [self.view setUserInteractionEnabled:YES];
                                           });
                                           [self getIntoTheApp];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           SHOW_ALERT(@"下载失败",@"请检查网络");
                                           [downloadTimer invalidate];
                                           [progressOverlayView displayOperationDidFinishAnimation];
                                           double delayInSeconds = progressOverlayView.stateChangeAnimationDuration;
                                           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                           dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                               progressOverlayView.progress = 0.;
                                               progressOverlayView.hidden = YES;
                                               [self.view setUserInteractionEnabled:YES];
                                           });
                                       }];
                                       [operation start];
                                     }
                                   failure:^(NSError *error) {
                                       SHOW_ALERT(@"获取压缩文件地址失败",@"请检查网络");
                                       [downloadTimer invalidate];
                                       [progressOverlayView displayOperationDidFinishAnimation];
                                       double delayInSeconds = progressOverlayView.stateChangeAnimationDuration;
                                       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                           progressOverlayView.progress = 0.;
                                           progressOverlayView.hidden = YES;
                                           [self.view setUserInteractionEnabled:YES];
                                       });
                                     }];
    return YES;
}

-(void)getIntoTheApp{
    NSString *dir = nil;
    for (int i = 0; i<[fileArray count];i++) {
        WXDFileKey *key = (WXDFileKey *)[fileArray objectAtIndex:i];
        WXDProjectInfo *infoCell = nil;
        if ([filteredArray count] > 0) {
            infoCell = filteredArray[[theChosenIndex integerValue]];
        }else{
            infoCell = theListInfo[[theChosenIndex integerValue]];
        }
        if ([key.keyName isEqualToString:infoCell.appID] == YES) {
            dir = key.filePath;
        }
    }
    wax_end();
    if (dir != nil) {
        NSString *pp = [[NSString alloc ] initWithFormat:@"%@/?.lua;%@/?/init.lua;", dir, dir];
        setenv(LUA_PATH, [pp UTF8String], 1);
        wax_start("patch", luaopen_wax_http, luaopen_wax_json,luaopen_wax_CTViewController,nil);
    }else{
        SHOW_ALERT(@"lua解析错误",@"dir is nil");
    }
}

-(void)searchDynamicGroup
{
    if ([fileArray count] > 0) {
        [fileArray removeAllObjects];
    }
    NSString *userDocDirPath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:[USER_DEFAULT objectForKey:@"userEmail"]];;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userDocDirPath error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [userDocDirPath stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir == YES) {
                WXDFileKey *key = [[WXDFileKey alloc] init];
                key.keyName = aPath;
                key.filePath = fullPath;
                [fileArray addObject:key];
            }
        }
    }
}

-(void)refreshList:(id)sender
{
    NSString *userEmail = [USER_DEFAULT objectForKey:@"userEmail"];
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL result;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_DIRECTORY error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir != YES && [fullPath rangeOfString:@".zip"].location != NSNotFound ) {
                if ([zip UnzipOpenFile:fullPath]) {
                    /**
                     *  目录的名字是用户邮件
                     */
                    NSString *userDocDir = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_DIRECTORY,userEmail];
                    result = [zip UnzipFileTo:userDocDir overWrite:YES];
                    if (!result) {
                        DLog(@"解压失败");
                    }
                    else
                    {
                        DLog(@"解压成功");
                        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                    }
                    [zip UnzipCloseFile];
                }
            }
        }
    }
    NSString *uselessFiles =[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"__MACOSX"];
    [[NSFileManager defaultManager] removeItemAtPath:uselessFiles error:nil];
    [self searchDynamicGroup];
}

-(void)fetchedData:(NSMutableArray*)projectsarr{
    NSData *decodedObject = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
    theLastListInfo = [NSKeyedUnarchiver unarchiveObjectWithData: decodedObject];
    theListInfo = [[NSMutableArray alloc]initWithArray:projectsarr];
    
    for (int i = 0 ; i<[projectsarr count]; i++) {
        WXDProjectInfo *infoCell = [projectsarr objectAtIndex:i];
        if ([theLastListInfo count] > 0) {
            for (WXDProjectInfo *lastInfoCell in theLastListInfo) {
                if ([infoCell.appID isEqualToString:lastInfoCell.appID] == YES) {
                    if (lastInfoCell.hasDL == YES) {
                        infoCell.hasDL = YES;
                        /**
                         *  如果发现项目被修改过，那么需要重新下载一次
                         */
                        if ([infoCell.editTime isEqualToString:lastInfoCell.editTime] == NO) {
                            infoCell.hasDL = NO;
                        }
                    }else{
                        infoCell.hasDL = NO;
                    }
                }
            }
        }
        /**
         *  在web端有字段增加
         */
        if ([theListInfo containsObject:infoCell] == NO) {
            [theListInfo addObject:infoCell];
        }
        /**
         *  在web端有字段被删除
         */
        if ([theLastListInfo count] > [projectsarr count]) {
            [self.mainTableView reloadData];
        }
    }
    /**
     *  存储最后一次的对象数组
     */
    theLastListInfo = [NSMutableArray arrayWithArray:theListInfo];
    NSData *encodeObject = [NSKeyedArchiver archivedDataWithRootObject:theLastListInfo];
    [USER_DEFAULT setObject:encodeObject forKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
    [USER_DEFAULT synchronize];
}

- (void)loadData:(NSString*)pressRefreshBtn{
    if ([WXDreach isReachable] == NO) {
            [self dismissError];
            [self.mainTableView setUserInteractionEnabled:YES];
            [self.mainTableView.headerView.activityView stopAnimating];
            [self.mainTableView tableViewDidFinishedLoadingWithMessage:@"刷新失败"];
        }else{
            WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
            [requestCommand command_fetch_projects_list:@"ios"
                                                  token:[USER_DEFAULT objectForKey:@"userToken"]
                                                success:^(NSMutableArray *projectsarr) {
                                                    [self fetchedData:projectsarr];
                                                    if ([pressRefreshBtn isEqualToString:@"0"] == YES) {//初始化时刷新列表
                                                        [SVProgressHUD showSuccessWithStatus:@"列表刷新完毕"];
                                                        [self.mainTableView setUserInteractionEnabled:YES];
                                                        [self.mainTableView reloadData];
                                                        self.refreshing = NO;
                                                    }
                                                    
                                                    if ([pressRefreshBtn isEqualToString:@"1"] == YES) {//按钮刷新
                                                        [SVProgressHUD showSuccessWithStatus:@"列表刷新完毕"];
                                                        [self.mainTableView setUserInteractionEnabled:YES];
                                                        [self.mainTableView reloadData];
                                                    }
                                                    
                                                    if ([pressRefreshBtn isEqualToString:@"2"] == YES) {//下拉刷新
                                                        [self.mainTableView setUserInteractionEnabled:YES];
                                                        [self.mainTableView.headerView.activityView stopAnimating];
                                                        [self.mainTableView tableViewDidFinishedLoadingWithMessage:@"刷新完毕"];
                                                        [self.mainTableView reloadData];
                                                    }
                                                    self.mainTableView.hidden = NO;
                                                } failure:^(NSError *error) {
                                                    SHOW_ALERT(@"抓取表单失败",[error localizedDescription]);
                                                    [self.mainTableView tableViewDidFinishedLoadingWithMessage:@"刷新失败"];
                                                    [SVProgressHUD dismiss];
                                                }];
        }
}

#pragma mark - --------------------按钮事件--------------------
- (IBAction)refreshClickOn:(id)sender {
    /**
     *  刷新列表时，列表不能互动
     */
    [self.mainTableView setUserInteractionEnabled:NO];
    [SVProgressHUD showWithStatus:@"正在刷新列表"];
    [self performSelector:@selector(loadData:) withObject:@"1" afterDelay:1.0];
}

- (IBAction)goSetting:(id)sender {
    WXDSettingViewController *settingVC = [[WXDSettingViewController alloc]initWithNavTitle:@"Setting"];
    settingVC.WXDNavVC = self.navigationController;
    [settingVC initParams];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - --------------------代理方法--------------------
#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    filteredArray = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"appName", searchText];
    filteredArray = [NSMutableArray arrayWithArray:[theListInfo filteredArrayUsingPredicate:predicateString]];
    if ([filteredArray count] > 0) {
        [self.mainTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""] == YES) {
        filteredArray = nil;
        [self.mainTableView reloadData];
    }
}

#pragma mark - WXDMainTableViewDelegate
- (void)WXDMainTableViewDidStartRefreshing:(WXDMainTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData:) withObject:@"2" afterDelay:1.0];
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
    /**
     *  本地缓存
     */
    if ([WXDreach isReachable] == NO) {
        NSData *myEncodedObject = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"theLastListInfo%@",[USER_DEFAULT objectForKey:@"userEmail"]]];
        theLastListInfo = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        theListInfo = [[NSMutableArray alloc]init];
        for (WXDProjectInfo * infoCell in theLastListInfo) {
            if (infoCell.hasDL == YES) {
                [theListInfo addObject:infoCell];
            }
        }
        return [theListInfo count];
    }else{
        if ([theListInfo count] > 0) {
            if ([filteredArray count] > 0) {
                 return [filteredArray count];
            }
            return [theListInfo count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WXDProjectTableViewCell";
    WXDProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    WXDProjectInfo *infoCell;
    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"WXDProjectTableViewCell" owner:self options:nil];
        cell = (WXDProjectTableViewCell *)[nibArray objectAtIndex:0];
    }
    /**
     *  离线状态，缓存
     */
    if ([WXDreach isReachable] == NO) {
        infoCell = theListInfo[indexPath.row];
        infoCell.hasDL = YES;
    }else{
        /**
         *  搜索框有内容
         */
        if ([filteredArray count] > 0) {
            infoCell = filteredArray[indexPath.row];
        }else{
            infoCell = theListInfo[indexPath.row];
        }
    }
    [cell.projectNameLabel setText:infoCell.appName];
    [cell.projectCommentLabel setText:infoCell.appDesc];
    cell.appID = infoCell.appID;
    cell.projectIconImageView.image = [UIImage imageNamed:@"icon-120.png"];
    if (infoCell.hasDL == YES) {
        cell.blueDotImageView.hidden = YES;
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
    if ([self.ProtoSearchBar isFirstResponder]==YES) {
        [self.ProtoSearchBar resignFirstResponder];
        if ([self.ProtoSearchBar.text isEqualToString:@""]==YES) {
            filteredArray = nil;
            [self.mainTableView reloadData];
        }
        return;
    }
    theChosenIndex = [NSNumber numberWithInteger:indexPath.row];
    WXDProjectInfo *infoCell;
    if ([filteredArray count] != 0) {
        infoCell = filteredArray[indexPath.row];
    }else{
        infoCell = theListInfo[indexPath.row];
    }

    if (infoCell.hasDL == YES) {
        [self searchDynamicGroup];
        [self getIntoTheApp];
    }else if (infoCell.hasDL == NO){
        for (WXDProjectTableViewCell *cell in tableView.visibleCells) {
            if ([cell.appID isEqualToString:infoCell.appID]== YES ) {
                progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:cell.projectIconImageView.bounds];
                [cell.projectIconImageView addSubview:progressOverlayView];
                [progressOverlayView displayOperationWillTriggerAnimation];
            }
        }
        [self.view setUserInteractionEnabled:NO];//下载期间，不能进行其他操作
        [self DownLoadZipFile];
    }
}

@end