//
//  CTActionModel.m
//  ToHell2iOS
//
//  Created by Anselz on 14-1-6.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "CTActionModel.h"

@implementation CTActionModel
@synthesize targetName;
@synthesize animationType;
@synthesize animationDirection;
@synthesize animationDurationTime;
@synthesize animationDelayTime;

-(id)init
{
    self = [super init];
    if (self){
        self.targetName = @"";
        self.animationType = @"";
        self.animationDirection = @"";
        self.animationDurationTime = @"";
        self.animationDelayTime = @"";
    }
    return self;
}
@end
