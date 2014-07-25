//
//  WXDRequestCommand.m
//  Protoshop
//
//  Created by kuolei on 3/17/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDRequestCommand.h"
#import "AFHTTPSessionManager.h"
#import "WXDStringUtility.h"
#import "WXDProjectInfo.h"

@interface WXDRequestCommand()

@end

@implementation WXDRequestCommand
{
    AFHTTPSessionManager *sessionManager;
}

DEFINE_SINGLETON_FOR_CLASS(WXDRequestCommand)

-(id) init
{
    self = [super init];
    if (self) {
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:__url_path]];
    }
    
    return self;
}

-(NSInteger) command_login:(NSString *)userName
                  password:(NSString *)password
                   success:(void(^)(WXDUserInfo *userInfo)) success//块指针，返回值，前一个方法需要的参数
                   failure:(void(^)(NSError *error)) failure;
{
    // userName is null
    if (userName == nil || [userName length] == 0 || [[WXDStringUtility trim:userName] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_EMAIL_ISNULL userInfo:@{NSLocalizedDescriptionKey:@"邮箱不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_EMAIL_ISNULL;
    }

    // password is null
    if (password == nil || [password length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_PWD_ISNULL userInfo:@{NSLocalizedDescriptionKey:@"密码不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_PWD_ISNULL;
    }
    
    // email is invalid
    if ([WXDStringUtility verifyEmail:userName] == NO) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_EMAIL_INVALID userInfo:@{NSLocalizedDescriptionKey:@"邮箱格式不正确"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_EMAIL_INVALID;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"email", [WXDStringUtility md5:password ], @"passwd", nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__login_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDUserResultInfo *resultInfo = [[WXDUserResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = [resultInfo resultState];
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  WXDUserInfo *userinfo = (WXDUserInfo *)[[resultInfo userResultInfoList] objectAtIndex:0];
                                                                  success(userinfo);
                                                              } else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey:resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
}

-(NSInteger) command_register:(NSString *)userName
                     password:(NSString *)password
                     nickName:(NSString *)nickName
                      success:(void(^)(WXDUserInfo *userInfo)) success
                      failure:(void(^)(NSError *error)) failure
{
    // userName is null
    if (userName == nil || [userName length] == 0 || [[WXDStringUtility trim:userName] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_EMAIL_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"邮箱不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_EMAIL_ISNULL;
    }
    
    // password is null
    if (password == nil || [password length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_PWD_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"密码不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_PWD_ISNULL;
    }
    
    // email is invalid
    if ([WXDStringUtility verifyEmail:userName] == NO) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_EMAIL_INVALID userInfo:@{NSLocalizedDescriptionKey: @"邮箱格式不正确"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_EMAIL_INVALID;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"email", [WXDStringUtility md5:password ], @"passwd", nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__sign_up_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDUserResultInfo *resultInfo = [[WXDUserResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  WXDUserInfo *userinfo = (WXDUserInfo *)[[resultInfo userResultInfoList] objectAtIndex:0];
                                                                  success(userinfo);
                                                              } else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;

}

-(NSInteger) command_update_password:(NSString *)newPassword
                         oldPassword:(NSString *)oldPassword
                      retypePassword:(NSString *)retypePassword
                               token:(NSString *)token
                             success:(void(^)(NSInteger state)) success
                             failure:(void(^)(NSError *error)) failure{
    // oldPassword is null
    if (oldPassword == nil || [oldPassword length] == 0 || [[WXDStringUtility trim:oldPassword] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_OLDPWD_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"旧密码不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_OLDPWD_ISNULL;
    }
    
    //newPassword and retypePassword are not equal or both of them are null
    if ([newPassword isEqualToString:retypePassword] == NO || newPassword == nil || [newPassword length] == 0 || [[WXDStringUtility trim:newPassword]length] == 0 || retypePassword == nil || [retypePassword length] == 0 || [[WXDStringUtility trim:retypePassword]length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_NEWPWD_INVALID userInfo:@{NSLocalizedDescriptionKey: @"新密码不能为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_NEWPWD_INVALID;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[WXDStringUtility md5:newPassword ], @"passwd", [WXDStringUtility md5:oldPassword ], @"oldpwd", token, @"token",nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__change_password_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDBaseResultInfo *resultInfo = [[WXDBaseResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  success(resultInfoState);
                                                              } else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;

}

-(NSInteger) command_fetch_projects_list:(NSString *)device
                                   token:(NSString *)token
                                 success:(void(^)( NSMutableArray *projectsarr)) success
                                 failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:device, @"device", token, @"token", nil];
    NSURLSessionDataTask * sessionTask = [sessionManager GET:__list_projects_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDProjectResultInfo *resultInfo = [[WXDProjectResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  NSMutableArray *projectsarr = [NSMutableArray arrayWithArray:[resultInfo projectResultInfoList]];
                                                                  success(projectsarr);
                                                              } else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;

}

-(NSInteger) command_create_zip_url:(NSString *)appid
                              token:(NSString *)token
                            success:(void(^)(NSString *zipurl)) success
                            failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    
    // appid is null
    if (appid == nil || [appid length] == 0 || [[WXDStringUtility trim:appid] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_APPID_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"appid为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_APPID_ISNULL;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:appid, @"appid", token, @"token", nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__create_zip_requrest
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDBaseResultInfo *resultInfo = [[WXDBaseResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  //其实，我觉得用同步的不是更加直观么
                                                                  NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                                                                  NSArray *resultList = [tempDic objectForKey:@"result"];
                                                                  success([resultList[0] objectForKey:@"url"]);
                                                              } else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
    
}

-(NSInteger) command_get_userinfo:(NSString *)token
                          success:(void(^)(WXDUserInfo *userInfo)) success
                          failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__get_user_info_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDUserResultInfo *resultInfo = [[WXDUserResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = [resultInfo resultState];
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  WXDUserInfo *userinfo = (WXDUserInfo *)[[resultInfo userResultInfoList] objectAtIndex:0];
                                                                  success(userinfo);
                                                              }  else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
    
}

-(NSInteger) command_update_userinfo:(NSString *)token
                            username:(NSString *)username
                            nickname:(NSString *)nickname
                             success:(void(^)(NSInteger state)) success
                             failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", username, @"username", nickname,@"nickname",nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__update_user_info_request
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDBaseResultInfo *resultInfo = [[WXDBaseResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  success(resultInfoState);
                                                              }  else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
}

-(NSInteger) command_send_feedback:(NSString *)token
                             email:(NSString *)email
                           content:(NSString *)content
                           success:(void(^)(NSInteger state)) success
                           failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", email, @"email", content,@"content",@"1",@"source",nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__feedback_requrest
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDBaseResultInfo *resultInfo = [[WXDBaseResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  success(resultInfoState);
                                                              }  else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
    
}

-(NSInteger) command_register_device:(NSString *)token
                         devicetoken:(NSData *)devicetoken
                             success:(void(^)(NSInteger state)) success
                             failure:(void(^)(NSError *error)) failure{
    // token is null
    if (token == nil || [token length] == 0 || [[WXDStringUtility trim:token] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_TOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"token为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_TOKEN_ISNULL;
    }
    
    // devicetoken is null
    if (devicetoken == nil || [devicetoken length] == 0 || [[WXDStringUtility trim:[[NSString alloc]initWithData:devicetoken encoding:NSUTF8StringEncoding]] length] == 0) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN code:PROTOSHOP_ERROR_DEVICETOKEN_ISNULL userInfo:@{NSLocalizedDescriptionKey: @"devicetoken为空"}];
            failure(error);
        }
        return PROTOSHOP_ERROR_DEVICETOKEN_ISNULL;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", devicetoken, @"devicetoken",nil];
    NSURLSessionDataTask * sessionTask = [sessionManager POST:__register_remote_notification
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *__unused task, id responseObject){
                                                          if (success) {
                                                              WXDBaseResultInfo *resultInfo = [[WXDBaseResultInfo alloc] initWithJsonObject:responseObject];
                                                              WXDResultStateInfo *resultState = resultInfo.resultState;
                                                              NSInteger resultInfoState = resultState.state;
                                                              if (resultInfoState == 0) {
                                                                  success(resultInfoState);
                                                              }  else {
                                                                  NSError *error = [NSError errorWithDomain:__PROTOSHOP_ERROR_DOMAIN
                                                                                                       code:resultInfoState
                                                                                                   userInfo:@{NSLocalizedDescriptionKey: resultState.message}];
                                                                  failure(error);
                                                              }
                                                          }
                                                      }
                                                      failure:^(NSURLSessionDataTask *__unused task, NSError *error){
                                                          if (failure) {
                                                              failure(error);
                                                          }
                                                      }];
    return sessionTask.taskIdentifier;
    
}

@end
