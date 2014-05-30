//
//  authconfig.h
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#ifndef CtripSSOAuth_authconfig_h
#define CtripSSOAuth_authconfig_h
#import "JSON.h"

#define AUTH_URL  @"http://10.2.254.48/ProtoShop/SSOLogin"
#define LOGOUT_URL  @"http://10.2.254.48/ProtoShop/SSOLogout"
#define CHECK_AUTH_URL  @"http://10.2.254.48/ProtoShop/SSOAuthCallBack/?type=mobile"

typedef enum {
    eAuthTypeDefault,
    eAuthTypePush,
}eAuthType;
#endif
