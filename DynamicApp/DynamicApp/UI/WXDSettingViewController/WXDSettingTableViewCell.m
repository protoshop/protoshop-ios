//
//  WXDSettingTableViewCell.m
//  Protoshop
//
//  Created by Anselz on 14-7-22.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "WXDSettingTableViewCell.h"

@implementation WXDSettingTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.iconLabel.font = [UIFont fontWithName:@"FontAwesome" size:24];
    self.arrowLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    _isShowConfirmButton = NO;
    
    _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(320, 0, 0, 44)];
    _confirmButton.backgroundColor = [UIColor redColor];
    [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_confirmButton];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showConfirmButton:(eTableViewCellActionType)type withAction:(void (^)())doActionBlock
{
    if (_isShowConfirmButton) {
        [UIView animateWithDuration:0.4 animations:^{
            _confirmButton.frame = CGRectMake(320, 0, 0, 44);
        } completion:^(BOOL finished) {
            [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        }];
        _isShowConfirmButton = NO;
    } else {
        self.cellActionType = type;
        self.block = doActionBlock;
        [UIView animateWithDuration:0.4 animations:^{
            _confirmButton.frame = CGRectMake(220, 0, 100, 44);
        }];
        _isShowConfirmButton = YES;
    }
}

-(void)confirmAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.cellActionType == eTableViewCellActionTypeLogout) {
        self.block();
    } else {
        UIActivityIndicatorView *acView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(180, 12, 20, 20)];
        [acView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [acView startAnimating];
        [self.contentView addSubview:acView];
        self.block();
        [acView removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            button.backgroundColor = [UIColor greenColor];
            [button setTitle:@"OK" forState:UIControlStateNormal];
        }];
       
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 animations:^{
                    button.frame = CGRectMake(320, 0, 100, 44);
                } completion:^(BOOL finished) {
                    _confirmButton.backgroundColor = [UIColor redColor];
                    [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
                    _isShowConfirmButton = NO;
                }];
            });
        });
    }
}
@end
