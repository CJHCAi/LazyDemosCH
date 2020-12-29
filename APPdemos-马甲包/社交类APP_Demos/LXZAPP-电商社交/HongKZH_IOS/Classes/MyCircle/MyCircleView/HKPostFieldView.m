//
//  HKPostFieldView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostFieldView.h"

@interface HKPostFieldView ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *textF;

@end



@implementation HKPostFieldView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame: frame]) {
        self.backgroundColor =[UIColor whiteColor];
        self.borderColor =[UIColor colorFromHexString:@"ffffff"];
        self.borderWidth =1;
    }
    return self;
}
-(UITextField *)textF {
    if (!_textF) {
        UITextField * text =[[UITextField alloc] init];
        text.placeholder = @"说说你的看法...";
        [text setValue:[UIColor colorFromHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [text setValue:PingFangSCRegular15 forKeyPath:@"_placeholderLabel.font"];
        text.delegate = self;
        text.keyboardType = UIKeyboardTypeDefault;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.textColor =[UIColor colorFromHexString:@"333333"];
        text.font = PingFangSCRegular15;
        text.returnKeyType =UIReturnKeySend;
        [self addSubview:text];
        _textF = text;
    }
    return _textF;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!textField.text.length) {
        [EasyShowTextView showText:@"评论的内容不能为空!"];
        return NO;
    }
    if (self.delegete && [self.delegete respondsToSelector:@selector(publishCommitWith:)]) {
        [self.delegete publishCommitWith:textField.text];
    }
    [self.textF resignFirstResponder];
    return YES;
    
}
-(void)layoutSubviews {
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self);
    }];
}
-(void)becomeFirstRespond {
    [self.textF becomeFirstResponder];
}

@end
