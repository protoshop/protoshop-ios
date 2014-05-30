//
//  WXDHomeTableViewCell.m
//  ToHell2iOS
//
//  Created by kuolei on 12/9/13.
//  Copyright (c) 2013 kuolei. All rights reserved.
//
//  Protoshop 主页面列表单元
//  归属人：虞鸿礼
//  修改时间：2014年5月13日

#import "WXDProjectTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WXDProjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) awakeFromNib
{
    _shareBtn.hidden = YES;
    _shareBtn.enabled = NO;
    _projectIconImageView.layer.cornerRadius = 12.;
    _projectIconImageView.layer.masksToBounds = YES;
    _projectIconImageView.layer.borderWidth = 0;
    _blueDotImageView.hidden = NO;
    //self.SyncBtn.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:36];//分享
}
@end