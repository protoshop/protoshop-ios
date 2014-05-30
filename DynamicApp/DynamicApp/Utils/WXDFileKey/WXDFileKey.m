//
//  GLFileKey.m
//  ToHell2iOS
//
//  Created by HongliYu on 13-12-12.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import "WXDFileKey.h"

@implementation WXDFileKey
-(id) init
{
    self = [super init];
    if (self != nil) {
        self.keyName = @"";
        self.filePath = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.keyName forKey:@"keyName"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.keyName = [aDecoder decodeObjectForKey:@"keyName"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
    }
    return self;
}
@end