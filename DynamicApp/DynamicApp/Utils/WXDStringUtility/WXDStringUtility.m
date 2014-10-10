//
//  WXDStringUtility.m
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDStringUtility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WXDStringUtility
+ (NSString *)toString:(id) object
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", object];
}

+ (NSString *)trim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)md5:(NSString *)string
{
    const char *cString = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; ++i)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

+ (BOOL) verifyEmail:(NSString *)string;
{
    NSString *match=@"\\S+@(\\S+\\.)+[\\S]{1,6}";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    BOOL valid = [predicate evaluateWithObject:string];
    return valid;
}

+ (NSString *)versin
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dict objectForKey:@"CFBundleVersion"];
}

+ (CGSize)calHeightForLabel:(NSString *)text
                      width:(CGFloat)width
                       font:(UIFont *)font {
    if ([text isKindOfClass:[[NSNull null] class]]) {
        return CGSizeMake(0, 0);
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect expectedFrame = [text boundingRectWithSize:CGSizeMake(width, 9999)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           font, NSFontAttributeName,
                                                           nil]
                                                  context:nil];
        return CGSizeMake(expectedFrame.size.width, ceil(expectedFrame.size.height)); //iOS7 is not rounding up to the nearest whole number
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        // CGSize size=[text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999)];
        CGSize size = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(width, 9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
        
        return size;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
}

@end
