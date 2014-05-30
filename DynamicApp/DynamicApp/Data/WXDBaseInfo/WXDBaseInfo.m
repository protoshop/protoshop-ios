//
//  WXDBaseInfo.m
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import "WXDBaseInfo.h"

@implementation WXDBaseInfo
@synthesize dictionary;

-(id) initWithJsonObject:(id)json
{
    self = [super init];
    if (self) {
        if (json && [json isKindOfClass:[NSDictionary class]]) {
            dictionary = [NSMutableDictionary dictionaryWithDictionary:json];
        }
    }
    
    return self;
}

@end
