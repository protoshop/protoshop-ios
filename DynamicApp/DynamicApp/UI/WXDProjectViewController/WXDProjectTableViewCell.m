/*
//  WXDHomeTableViewCell.m
//  ToHell2iOS
//
//  Created by kuolei on 12/9/13.
//  Copyright (c) 2013 kuolei. All rights reserved.
//
//  Protoshop 主页面列表单元
//  归属人：虞鸿礼
//  修改时间：2014年5月13日
*/

#import "WXDProjectTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DAProgressOverlayView.h"
#import "AFURLSessionManager.h"
#import "AFNetworking.h"
#import "WXDRequestCommand.h"

/** lua解析器*/
#import "lauxlib.h"
#import "wax.h"

/** wax扩展*/
#import "wax_http.h"
#import "wax_json.h"
#import "wax_xml.h"
#import "wax_CTViewController.h"
/*
 zip lib
 */
#import "ZipArchive.h"

@interface WXDProjectTableViewCell()

@property (strong, nonatomic) DAProgressOverlayView *progressView;
@property (strong, nonatomic) NSString *appPath;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

-(void) unzipApp:(NSString *) zipFile;
/**
 The funciton for cancel download
 */
-(void) cancelDownloadTask:(NSNotification*) notification;

@end

@implementation WXDProjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) awakeFromNib
{
    _shareBtn.hidden = YES;
    _shareBtn.enabled = NO;
    _projectIconImageView.layer.cornerRadius = 2.0;
    _projectIconImageView.layer.masksToBounds = YES;
    _projectIconImageView.layer.borderWidth = 0;
    _blueDotImageView.hidden = NO;
    _progressView = [[DAProgressOverlayView alloc] initWithFrame:_projectIconImageView.bounds];
    _progressView.hidden = YES;
    [_projectIconImageView addSubview:_progressView];

    //self.SyncBtn.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:36];//分享
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelDownloadTask:) name:__Protoshop_Cancle_Download object:nil];
}

-(void) cancelDownloadTask:(NSNotification*) notification
{
    if (_downloadTask != nil && _downloadTask.state == NSURLSessionTaskStateRunning) {
        [_downloadTask cancel];
        
        [_progressView displayOperationDidFinishAnimation];
        double delayInSeconds = _progressView.stateChangeAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _progressView.progress = 0.;
            _progressView.hidden = YES;
        });

    }
}

/*
    download the package of project.
 */
-(void) downloadProjectPackage
{
    if (_projectInfo.bDownload == YES) {
        [self gotoApp];
        return;
    };
    
    _progressView.hidden = NO;
    [_progressView displayOperationWillTriggerAnimation];

    WXDRequestCommand *requestCommand = [WXDRequestCommand sharedWXDRequestCommand];
    [requestCommand command_create_zip_url:_projectInfo.appID
                                     token:[USER_DEFAULT objectForKey:@"userToken"]
                                   success:^(NSString *zipPath) {
                                       NSURL *url = [NSURL URLWithString:zipPath];
                                       NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                       AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                                       NSProgress *progress = nil;
                                       
                                       _downloadTask = [session downloadTaskWithRequest:request
                                                                               progress:&progress
                                                                            destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                                 NSString *filePath = [targetPath resourceSpecifier];
                                                                                 
                                                                                 [self unzipApp:[filePath stringByReplacingOccurrencesOfString:@"%20" withString:@" "]];
                                                                                 [_progressView displayOperationDidFinishAnimation];
                                                                                 double delayInSeconds = _progressView.stateChangeAnimationDuration;
                                                                                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                                                                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                                     _progressView.progress = 0.;
                                                                                     _progressView.hidden = YES;
                                                                                 });
                                                                                 return [NSURL fileURLWithPath:@"/tmp/robots.txt"];
                                                                             }
                                                                      completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                           DLog(@"error");
                                                                       }];
                                       [_downloadTask resume];
                                       
                                       [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                                           float progress = (float)totalBytesWritten /(float)totalBytesExpectedToWrite;
                                           __weak DAProgressOverlayView *weakView = _progressView;
                                           [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                               weakView.progress = progress;
                                           }];
                                       }];
                                   }
                                   failure:^(NSError *error) {
                                       SHOW_ALERT(@"获取压缩文件地址失败",@"请检查网络");
                                       [_progressView displayOperationDidFinishAnimation];
                                       double delayInSeconds = _progressView.stateChangeAnimationDuration;
                                       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                           _progressView.progress = 0.;
                                           _progressView.hidden = YES;
                                       });
                                       
                                   }];
}

-(void) unzipApp:(NSString *)zipFile
{
    NSString *userEmail = [USER_DEFAULT objectForKey:@"userEmail"];
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL result;
    if ([zip UnzipOpenFile:zipFile]) {
        /**
         *  目录的名字是用户邮件
         */
        NSString *userDocDir = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_DIRECTORY,userEmail];
        result = [zip UnzipFileTo:userDocDir overWrite:YES];
        if (!result) {
            NSLog(@"解压失败");
        }
        else
        {
            DLog(@"解压成功");
            _projectInfo.appPath = [NSString stringWithFormat:@"%@/%@", userDocDir, _projectInfo.appID];
            _projectInfo.bDownload = YES;
            _blueDotImageView.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:__Protoshop_Project_State_Changed object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:__Protoshop_Reload_TableCell object:_projectInfo.appID];

        }
        [zip UnzipCloseFile];
    }

    NSString *uselessFiles =[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"__MACOSX"];
    [[NSFileManager defaultManager] removeItemAtPath:uselessFiles error:nil];
    
}

/*
 
 */
-(void) gotoApp
{
    wax_end();
    if (_projectInfo.appPath != nil) {
        NSString *pp = [[NSString alloc ] initWithFormat:@"%@/?.lua;%@/?/init.lua;", _projectInfo.appPath, _projectInfo.appPath];
        setenv(LUA_PATH, [pp UTF8String], 1);
        wax_start("patch", luaopen_wax_http, luaopen_wax_json,luaopen_wax_CTViewController,nil);
    }else{
        SHOW_ALERT(@"lua解析错误",@"dir is nil");
    }

}

@end