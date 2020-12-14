//
//  DLMaxLinkTextField.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/25.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLMaxLinkTextFieldView.h"
#import "Masonry.h"

@interface DLMaxLinkTextFieldView ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) NSUInteger maxNum;
@end

@implementation DLMaxLinkTextFieldView

- (id)init{
    self = [super init];
    if (self) {
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.text = @"1";
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)configTextFieldWithMaxNum:(NSUInteger)maxNum {
    self.maxNum = maxNum;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        textField.text = [NSString stringWithFormat:@"%@",@(1)];
        self.linkNumberBlock(1 ,YES);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length <=0) {
        return YES;
    }
    NSString *resultString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (resultString.integerValue > self.maxNum) {
        textField.text = [NSString stringWithFormat:@"%@",@(self.maxNum)];
        self.linkNumberBlock(self.maxNum ,YES);
        return NO;
    } else if (resultString.integerValue >= 1 && textField.text.integerValue <= self.maxNum) {
        self.linkNumberBlock(resultString.integerValue ,NO);
        return YES;
    } else if (resultString.integerValue < 1) {
        textField.text = [NSString stringWithFormat:@"%@",@(1)];
        self.linkNumberBlock(1 ,YES);
        return NO;
    }
    return YES;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}
@end
