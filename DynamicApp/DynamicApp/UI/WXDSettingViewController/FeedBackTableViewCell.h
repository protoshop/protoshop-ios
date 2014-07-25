//
//  FeedBackTableViewCell.h
//  Protoshop
//
//  Created by Anselz on 14-7-23.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionBlock)();
typedef void (^feedBackBlock)(NSString *context);

@interface FeedBackTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic,copy) feedBackBlock feedBackBlock;
@property (nonatomic,copy) actionBlock feedBackStartEditBlock;
@property (nonatomic,copy) actionBlock feedBackEndEditBlock;

-(void)showFeedBackTextField:(void (^)(NSString *context))feedBackBlock
                   startEdit:(void (^)())startActionBlock
                     endEdit:(void (^)())endActionBlock;
@end
