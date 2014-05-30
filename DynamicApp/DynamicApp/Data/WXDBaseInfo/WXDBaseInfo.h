//
//  WXDBaseInfo.h
//  Protoshop
//
//  Created by kuolei on 3/13/14.
//  Copyright (c) 2014 kuolei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDBaseInfo : NSObject
{
    NSMutableDictionary *dictionary;
}
@property (nonatomic, strong) NSMutableDictionary *dictionary;

-(id) initWithJsonObject:(id)json;

@end
