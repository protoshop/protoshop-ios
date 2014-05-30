//
//  WXDHomeTableViewCell.h
//  ToHell2iOS
//
//  Created by kuolei on 12/9/13.
//  Copyright (c) 2013 kuolei. All rights reserved.
//
//  Protoshop 主页面列表单元
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import <UIKit/UIKit.h>

@interface WXDProjectTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *projectCommentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *projectIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *blueDotImageView;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong,nonatomic) NSString *appID;
@end