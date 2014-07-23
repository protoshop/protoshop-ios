//
//  WXDSettingTableViewCell.h
//  Protoshop
//
//  Created by Anselz on 14-7-22.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    eTableViewCellActionTypeClear,
    eTableViewCellActionTypeLogout
}eTableViewCellActionType;

typedef void (^doActionBlock)();

@interface WXDSettingTableViewCell : UITableViewCell
{
    BOOL _isShowConfirmButton;
    UIButton *_confirmButton;
}

@property (nonatomic,copy) doActionBlock block;

@property (nonatomic,assign) eTableViewCellActionType cellActionType;


-(void)showConfirmButton:(eTableViewCellActionType)type withAction:(void (^)())doActionBlock;

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@end
