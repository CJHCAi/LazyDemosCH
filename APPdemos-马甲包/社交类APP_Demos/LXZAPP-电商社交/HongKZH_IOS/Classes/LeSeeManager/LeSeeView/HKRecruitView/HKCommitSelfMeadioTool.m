//
//  HKCommitSelfMeadioTool.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCommitSelfMeadioTool.h"
@interface HKCommitSelfMeadioTool()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKCommitSelfMeadioTool
-(void)awakeFromNib{
    [super awakeFromNib];
    self.textField.delegate = self;
    self.textField.returnKeyType =UIReturnKeySend;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length>0) {
        if (self.type == 0) {
            if ([self.delegate respondsToSelector:@selector(commitWithText:)]) {
                [self.delegate commitWithText:textField.text];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(commitCommentWithText:)]) {
                [self.delegate commitCommentWithText:textField.text];
            }
        }
    }
    return YES;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKCommitSelfMeadioTool" owner:self options:nil].lastObject;
    if (self) {
        self.frame = frame;
    }
    return self;
}
-(void)setType:(int)type{
    _type = type;
    if (type < 0) {
        self.textField.text = @"";
        [self.textField resignFirstResponder];
        self.btn.hidden = NO;
    }else{
        _btn.hidden = YES;
    }
    [self.textField becomeFirstResponder];
}
- (IBAction)btnclick:(UIButton*)sender {
    self.type = 0;
}
-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
