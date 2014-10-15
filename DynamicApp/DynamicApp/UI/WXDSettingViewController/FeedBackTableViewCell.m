//
//  FeedBackTableViewCell.m
//  Protoshop
//
//  Created by Anselz on 14-7-23.
//  Copyright (c) 2014年 kuolei. All rights reserved.
//

#import "FeedBackTableViewCell.h"

@implementation FeedBackTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.iconLabel.font = [UIFont fontWithName:@"Ionicons" size:24];
    self.arrowLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    self.textView.delegate = self;
    self.textView.text = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationAction) name:@"DismissKeyBoard" object:nil];
    [self.sendButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:138.0/255.0 blue:37.0/255.0 alpha:0.4] forState:UIControlStateNormal];
}

-(void)handleNotificationAction
{
    [self.textView resignFirstResponder];
    if (self.feedBackEndEditBlock) {
        self.feedBackEndEditBlock();
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DismissKeyBoard" object:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showFeedBackTextField:(void (^)(NSString *context))feedBackBlock
                   startEdit:(void (^)())startActionBlock
                     endEdit:(void (^)())endActionBlock
{
    if (!self.feedBackBlock) {
        self.feedBackBlock = feedBackBlock;
    }
    if (!self.feedBackEndEditBlock) {
        self.feedBackEndEditBlock = endActionBlock;
    }
    if (!self.feedBackStartEditBlock) {
        self.feedBackStartEditBlock = startActionBlock;
    }
    self.textView.text = @"请留下您宝贵的意见和建议";
    self.textView.textColor = [UIColor grayColor];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textView.textColor = [UIColor blackColor];
    textView.text = @"";
    if (self.feedBackStartEditBlock) {
        self.feedBackStartEditBlock();
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.feedBackEndEditBlock) {
        self.feedBackEndEditBlock();
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [self.sendButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:138.0/255.0 blue:37.0/255.0 alpha:0.4] forState:UIControlStateNormal];
    } else {
        [self.sendButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:138.0/255.0 blue:37.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    if (textView.text.length <= 240) {
        self.statusLabel.text = [NSString stringWithFormat:@"%d",240 - textView.text.length];
    } else {
        textView.text = [textView.text substringToIndex:240];
    }
}
- (IBAction)sendMessageAction:(id)sender {
    if (self.textView.text.length == 0 ||[self.textView.text isEqualToString:@"请留下您宝贵的意见和建议"]) {
        return;
    }
    [self.textView resignFirstResponder];
    if (self.feedBackBlock) {
        self.feedBackBlock(self.textView.text);
    }
}
@end
