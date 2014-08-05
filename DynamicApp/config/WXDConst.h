//
//  WXDConst.h
//  Protoshop
//
//  Created by kuolei on 3/17/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#ifndef __PROTOSHOP_WXDCONST_H__
#define __PROTOSHOP_WXDCONST_H__
#import "WXDConfig.h"

//#define PROTOSHOP_WWW       //FOR www.protoshop.io
//#define PROTOSHOP_DEBUG

#ifdef PROTOSHOP_WWW
    static NSString *const __url_path = @"http://api.protoshop.io";
    static NSString *const __reachability_path = @"api.protoshop.io";
    static BOOL const isSSOLoginHidden = YES;
#else
    static NSString *const __reachability_path = @"git.dev.sh.ctripcorp.com";
    static BOOL const isSSOLoginHidden = NO;
    #ifdef PROTOSHOP_DEBUG
        static NSString *const __url_path = @"http://protoshop.ctripqa.com/ProtoShop/";
    #else
        static NSString *const __url_path = @"http://protoshop.ctripqa.com/ProtoShop/";
    #endif
#endif // PROTOSHOP_WWW

/**
 Request String
 */
static NSString *const __create_zip_requrest = @"createZip/";
static NSString *const __list_projects_request = @"fetchlist/"; //get project list
static NSString *const __login_request = @"login/";
static NSString *const __sign_up_request = @"register/";
static NSString *const __change_password_request = @"updatepwd/";
static NSString *const __feedback_requrest = @"feedback/";
static NSString *const __get_user_info_request = @"userinfo/";
static NSString *const __update_user_info_request = @"updateuser/";
static NSString *const __register_remote_notification = @"registerdevice/";

/**
 Application Error Domain
 */
static NSString *const __PROTOSHOP_ERROR_DOMAIN = @"PROTOSHOP_ERROR_DOMAIN";
static NSString *const __PROTOSHOP_REQEEST_ERROR_DOMAIN = @"PROTOSHOP_REQEEST_ERROR_DOMAIN";

/**
 PROTOSHOP ERROR ENUM
 */
typedef NS_ENUM(NSUInteger, __ENUM_PROTOSHOP_ERROR_CODE) {
    PROTOSHOP_ERROR_NOERROR                 = 0,       // no error
    PROTOSHOP_ERROR_EMAIL_ISNULL            = 1,       // email is null
    PROTOSHOP_ERROR_PWD_ISNULL              = 2,       // password is null
    PROTOSHOP_ERROR_EMAIL_INVALID           = 3,       // email is invalid (xxx@xxx.com)
    PROTOSHOP_ERROR_OLDPWD_ISNULL           = 4,       // newpassword is null
    PROTOSHOP_ERROR_NEWPWD_INVALID          = 5,       // oldPassword and retypePassword are not equal or both of them are null
    PROTOSHOP_ERROR_TOKEN_ISNULL            = 6,       // user token is null
    PROTOSHOP_ERROR_APPID_ISNULL            = 7,       // appID is null
    PROTOSHOP_ERROR_DEVICETOKEN_ISNULL      = 8,       // device token is null

};

/**
 The Dictionary of Error String
 */
static NSDictionary *__Protoshop_Error_Dictionary = nil;

/**
 The String of Location Notification
 */
static NSString *const __Protoshop_Project_State_Changed = @"PROTOSHOP_PROJECT_STATE_CHANGED";

/**
 The String of Projects list
 */
static NSString *const __Protoshop_Project_List = @"PROTOSHOP_PROJECT_LIST%@";

/**
 The Notification for reload table cell
 */
static NSString *const __Protoshop_Reload_TableCell = @"Protoshop_Reload_TableCell";

/**
 The Notification for clear cache
 */
static NSString *const __Protoshop_Clear_Cache = @"__Protoshop_Clear_Cache";

#endif //__PROTOSHOP_WXDCONST_H__














