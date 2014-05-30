//
//  WXDRequestCommand.h
//  Protoshop
//
//  Created by kuolei on 3/17/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXDUserInfo.h"
#import "WXDConfig.h"

@interface WXDRequestCommand : NSObject
DEFINE_SINGLETON_FOR_HEADER(WXDRequestCommand)

-(NSInteger) command_login:(NSString *)userName
                  password:(NSString *)password
                   success:(void(^)(WXDUserInfo *userInfo)) success
                   failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_register:(NSString *)userName
                     password:(NSString *)password
                     nickName:(NSString *)nickName
                      success:(void(^)(WXDUserInfo *userInfo)) success
                      failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_update_password:(NSString *)newPassword
                         oldPassword:(NSString *)oldPassword
                      retypePassword:(NSString *)retypePassword
                               token:(NSString *)token
                             success:(void(^)(NSInteger state)) success
                             failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_fetch_projects_list:(NSString *)device
                         token:(NSString *)token
                             success:(void(^)(NSMutableArray *projectsarr)) success
                             failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_create_zip_url:(NSString *)appid
                                   token:(NSString *)token
                                 success:(void(^)(NSString *zipurl)) success
                                 failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_get_userinfo:(NSString *)token
                            success:(void(^)(WXDUserInfo *userInfo)) success
                            failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_update_userinfo:(NSString *)token
                            username:(NSString *)username
                            nickname:(NSString *)nickname
                          success:(void(^)(NSInteger state)) success
                          failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_send_feedback:(NSString *)token
                            email:(NSString *)email
                            content:(NSString *)content
                             success:(void(^)(NSInteger state)) success
                             failure:(void(^)(NSError *error)) failure;

-(NSInteger) command_register_device:(NSString *)token
                             devicetoken:(NSData *)devicetoken
                           success:(void(^)(NSInteger state)) success
                           failure:(void(^)(NSError *error)) failure;
@end
