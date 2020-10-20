//
//  SDInputTagContentView.m
//  NestHouse
//
//  Created by shansander on 2017/5/8.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDInputTagContentView.h"
#import "AppFileComment.h"
CGFloat const height_input_contentView = 50.f;

@implementation SDInputTagContentView

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        UITextField * theView = [[UITextField alloc] init];
        [self.inputText_bg_view addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputText_bg_view).offset(10);
            make.top.equalTo(self.inputText_bg_view);
            make.bottom.equalTo(self.inputText_bg_view);
            make.right.equalTo(self.inputText_bg_view).offset(-5);
        }];
        theView.clearButtonMode = UITextFieldViewModeAlways;
    
        _inputTextField = theView;
    }
    return _inputTextField;
}
- (UIView *)inputText_bg_view
{
    if (!_inputText_bg_view) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.cancel_button.mas_right);
            make.right.equalTo(self.ok_button.mas_left).offset(-5);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        theView.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
        _inputText_bg_view = theView;
    }
    return _inputText_bg_view;
}

- (UIButton *)cancel_button
{
    if (!_cancel_button) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50.f);
        }];
        NSString * imageLink = [AppFileComment imagePathStringWithImagename:@"close_icon"];

        [theView setImage:[UIImage imageNamed:imageLink] forState:UIControlStateNormal];
        [theView setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        _cancel_button = theView;
    }
    return _cancel_button;
}

- (UIButton *)ok_button
{
    if (!_ok_button) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50.f);
        }];
        
        [theView setTitle:@"完成" forState:UIControlStateNormal];
        [theView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _ok_button = theView;
    }
    return _ok_button;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, height_input_contentView);
    
        [self configView];
        
    }
    return self;
}
- (void)configView
{
    @weakify_self
    [[[self cancel_button] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify_self
        if (self.doneBlock) {
            self.doneBlock(nil);
        }
    }];
    
    
    [[[self ok_button] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify_self
        if (self.doneBlock) {
            self.doneBlock(self.inputTextField.text);
        }
    }];
    [self inputText_bg_view];
    self.inputTextField.placeholder = @"输入";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_inputText_bg_view) {
        _inputText_bg_view.layer.masksToBounds = true;
        _inputText_bg_view.layer.cornerRadius = _inputText_bg_view.frame.size.height / 2.f;
    }
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
