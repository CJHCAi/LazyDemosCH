//
//  SXTNextLandingView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTNextLandingView.h"

@interface SXTNextLandingView()<UITextFieldDelegate>
@property (strong, nonatomic)   UILabel *tostLabel;              /** 提示验证码发送到哪个手机号的label */
@property (strong, nonatomic)   UILabel *backLabel;              /** 背景label */
@property (strong, nonatomic)   UITextField *codeText;              /** 验证码输入框 */
@property (strong, nonatomic)   UIButton *timeButton;              /** 显示倒计时button */
@property (strong, nonatomic)   UILabel *lineLabel;              /** 竖线 */
@property (strong, nonatomic)   UIButton *landingButton;              /** 注册button */
@end

@implementation SXTNextLandingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tostLabel];
        [self addSubview:self.backLabel];
        [self addSubview:self.codeText];
        [self addSubview:self.timeButton];
        [self addSubview:self.lineLabel];
        [self addSubview:self.landingButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    
    [_tostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.top.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).offset(15);
    }];
    
    [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.top.equalTo(weakSelf.tostLabel.mas_bottom);
        make.left.equalTo(weakSelf.mas_left).offset(-1);
        make.right.equalTo(weakSelf.mas_right).offset(1);
    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backLabel.mas_left).offset(15);
        make.top.bottom.equalTo(weakSelf.backLabel);
        make.right.equalTo(weakSelf.backLabel.mas_right).offset(VIEW_WIDTH-110);
    }];
    
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.right.top.equalTo(weakSelf.backLabel);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 30));
        make.centerY.equalTo(weakSelf.backLabel.mas_centerY);
        make.right.equalTo(weakSelf.timeButton.mas_left).offset(-1);
    }];
    
    [_landingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(16);
        make.right.equalTo(weakSelf.mas_right).offset(-16);
        make.height.equalTo(@35);
        make.top.equalTo(weakSelf.codeText.mas_bottom).offset(15);
    }];
}

- (void)setPhoneNumString:(NSString *)phoneNumString{
    _phoneNumString = phoneNumString;
    _tostLabel.attributedText = [self makeTostLabelAttributed];
}

- (UILabel *)tostLabel{
    if (!_tostLabel) {
        _tostLabel = [[UILabel alloc]init];
        _tostLabel.text = @"验证码已经发送到+ 86";
        _tostLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _tostLabel;
}

- (UILabel *)backLabel{
    if (!_backLabel) {
        _backLabel = [[UILabel alloc]init];
        _backLabel.backgroundColor = [UIColor whiteColor];
        _backLabel.layer.borderWidth = 1;
        _backLabel.layer.borderColor = RGB(188, 188, 188).CGColor;
    }
    return _backLabel;
}

- (UITextField *)codeText{
    if (!_codeText) {
        _codeText = [[UITextField alloc]init];
        _codeText.delegate = self;
        _codeText.placeholder = @"请输入验证码";
        [_codeText addTarget:self action:@selector(codeTextChangeText:) forControlEvents:(UIControlEventEditingChanged)];
        
    }
    return _codeText;
}

- (UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_timeButton addTarget:self action:@selector(GCDTime) forControlEvents:(UIControlEventTouchUpInside)];
        [_timeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _timeButton;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = RGB(188, 188, 188);
    }
    return _lineLabel;
}

- (UIButton *)landingButton{
    if (!_landingButton) {
        _landingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_landingButton setTitle:@"注册" forState:(UIControlStateNormal)];
        _landingButton.backgroundColor = RGB(229, 229, 229);
        _landingButton.userInteractionEnabled = NO;
        [_landingButton setTitleColor:RGB(132, 132, 132) forState:(UIControlStateNormal)];
        [_landingButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _landingButton.selected = NO;
        [_landingButton addTarget:self action:@selector(landingMethod) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _landingButton;
}



- (void)codeTextChangeText:(UITextField *)textField{
    if (textField.text.length == 6) {
        self.landingButton .userInteractionEnabled = YES;
        self.landingButton.backgroundColor = RGB(56, 166, 241);
        self.landingButton.selected = YES;
    }else{
        self.landingButton .userInteractionEnabled = NO;
        self.landingButton.backgroundColor = RGB(229, 229, 229);
        self.landingButton.selected = NO;
    }
}

#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 6) {
        return NO;
    }
    return YES;
}

#pragma mark - makeAttribute
//制作tostLabel的属性文本
- (NSMutableAttributedString *)makeTostLabelAttributed{
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:@"验证码已经发送到 " attributes:@{NSForegroundColorAttributeName:RGB(139, 139, 139)}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"+86 %@",_phoneNumString] attributes:@{NSForegroundColorAttributeName:RGB(56, 166, 243)}];
    
    [string1 insertAttributedString:string2 atIndex:string1.length];
    return string1;
}
//制作timeButton的属性文本
- (NSMutableAttributedString *)makeTimeButtonAttributed:(NSInteger)time{
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%li",time] attributes:@{NSForegroundColorAttributeName:RGB(56, 166, 243)}];
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc]initWithString:@"秒后重试" attributes:@{NSForegroundColorAttributeName:RGB(139, 139, 139)}];
    
    [string3 insertAttributedString:string4 atIndex:string3.length];
    return string3;
}
#pragma mark - time
- (void)GCDTime{
    
    __block NSInteger time = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (time < 1) {
            dispatch_source_cancel(timer);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"重新发送" attributes:@{NSForegroundColorAttributeName:RGB(56, 166, 243)}];
            dispatch_async(dispatch_get_main_queue(), ^{
                _timeButton.userInteractionEnabled = YES;
                [_timeButton setAttributedTitle:string forState:(UIControlStateNormal)];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _timeButton.userInteractionEnabled = NO;
                [_timeButton setAttributedTitle:[self makeTimeButtonAttributed:time] forState:(UIControlStateNormal)];
            });
            time --;
        }
    });
    dispatch_resume(timer);
}

- (void)landingMethod{
    if (_landingBlock) {
        _landingBlock(_codeText.text);
    }
}
@end
