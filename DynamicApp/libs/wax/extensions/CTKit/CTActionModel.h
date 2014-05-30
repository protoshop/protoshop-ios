//
//  CTActionModel.h
//  ToHell2iOS
//
//  Created by Anselz on 14-1-6.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTActionModel : NSObject

@property (nonatomic,strong) NSString *targetName;
@property (nonatomic,strong) NSString *animationType;
@property (nonatomic,strong) NSString *animationDirection;
@property (nonatomic,strong) NSString *animationDurationTime;
@property (nonatomic,strong) NSString *animationDelayTime;
@end
