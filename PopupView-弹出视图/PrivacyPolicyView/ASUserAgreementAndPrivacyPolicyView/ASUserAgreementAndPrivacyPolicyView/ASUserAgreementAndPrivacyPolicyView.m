//
//  ASUserAgreementAndPrivacyPolicyView.m
//  ASUserAgreementAndPrivacyPolicyView
//
//  Created by Mac on 2020/1/5.
//  Copyright © 2020 Mac. All rights reserved.
// 远程缩影 https://github.com/2020NewDemo/ASUserAgreementAndPrivacyPolicyView.git
// 远程代码仓库  https://github.com/2020NewDemo/ASUserAgreementAndPrivacyPolicyViewKit.git

// Cloning 'https://github.com/2020NewDemo/ASUserAgreementAndPrivacyPolicyViewKit.git'

#import "ASUserAgreementAndPrivacyPolicyView.h"
#import <Masonry.h>

@interface ASUserAgreementAndPrivacyPolicyView ()

@property (nonatomic, strong) UIView * mainView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UITextView * contentTextView;

@property (nonatomic, strong) UIButton * agreeButton;

@property (nonatomic, strong) UIButton * disAgreeButton;

@property (nonatomic, copy) void(^isAgreeOperation)(BOOL isAgree);

@end

static ASUserAgreementAndPrivacyPolicyView *_userAgreementAndPrivacyPolicyView = nil;

@implementation ASUserAgreementAndPrivacyPolicyView

- (instancetype)init {
    
    if (self == [super init]) {
        
        [self setupUI];
    }
    return self;
}

+ (instancetype)showUserAgreementAndPrivacyPolicyViewIsAgreeOperation:(void (^)(BOOL))isAgreeOperation {
    
    if (_userAgreementAndPrivacyPolicyView == nil) {
        
        _userAgreementAndPrivacyPolicyView = [[self alloc] init];
        _userAgreementAndPrivacyPolicyView.frame = [UIScreen mainScreen].bounds;
        _userAgreementAndPrivacyPolicyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
        [mainWindow addSubview:_userAgreementAndPrivacyPolicyView];
        
        _userAgreementAndPrivacyPolicyView.isAgreeOperation = isAgreeOperation;
    }
    return _userAgreementAndPrivacyPolicyView;
}

- (void)setupUI {
    
    CGSize mainViewSize = CGSizeMake(300, 350);
    
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(mainViewSize);
    }];
    
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainView);
        make.top.mas_equalTo(self.mainView).offset(20);
        make.size.mas_equalTo(CGSizeMake(400, 20));
    }];
    
    [self.mainView addSubview:self.disAgreeButton];
    [self.disAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainView);
        make.bottom.mas_equalTo(self.mainView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(150, 15));
    }];
    
    [self.mainView addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainView);
        make.bottom.mas_equalTo(self.disAgreeButton.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(150, 35.5));
    }];
    
    [self.mainView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mainView).offset(30);
        make.right.mas_equalTo(self.mainView).offset(-30);
        make.bottom.mas_equalTo(self.agreeButton.mas_top).offset(-30);
    }];
    
}

+ (void)hiddenUserAgreementAndPrivacyPolicyView {
    
    [_userAgreementAndPrivacyPolicyView removeFromSuperview];
    _userAgreementAndPrivacyPolicyView = nil;
}

- (void)hiddenUserAgreementAndPrivacyPolicyView {
    
    [_userAgreementAndPrivacyPolicyView removeFromSuperview];
    _userAgreementAndPrivacyPolicyView = nil;
}

- (void)agreeButtonAction {
    
    // 关闭弹窗
    [self hiddenUserAgreementAndPrivacyPolicyView];
    if (self.isAgreeOperation) {
        self.isAgreeOperation(YES);
    }
}

- (void)disAgreeButtonAction {
    
    // 退出APP
    if (self.isAgreeOperation) {
        self.isAgreeOperation(NO);
    }
}

- (NSString *)contentText {
    
    NSString *content = @"欢迎来到AClassroom！\n \
1.为了更好提供上课、预习、复习等上课内容，我们会根据您使用的具体功能需要，收集必要的用户信息；\n \
2.未经您授权，我们不会与第三方共享或对外提供您的信息； \n \
3.您可以访问、更正、删除您的个人信息，我们也将提供注销和更正方式。\n \
请仔细阅读完整版AClassroom《用户服务协议》和《隐私政策》，点击同意即表示您已阅读并同意全部条款。\n\
    欢迎来到AClassroom！\n \
    1.为了更好提供上课、预习、复习等上课内容，我们会根据您使用的具体功能需要，收集必要的用户信息；\n \
    2.未经您授权，我们不会与第三方共享或对外提供您的信息； \n \
    3.您可以访问、更正、删除您的个人信息，我们也将提供注销和更正方式。\n \
    请仔细阅读完整版AClassroom《用户服务协议》和《隐私政策》，点击同意即表示您已阅读并同意全部条款。";
    
    return content;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.layer.cornerRadius = 10;
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"服务条款和隐私保护协议";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textColor = [UIColor lightGrayColor];
        _contentTextView.text = [self contentText];
        _contentTextView.userInteractionEnabled = NO;
        _contentTextView.font = [UIFont systemFontOfSize:15];
    }
    return _contentTextView;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        _agreeButton.backgroundColor = [UIColor yellowColor];
        _agreeButton.layer.cornerRadius = 17.5;
        _agreeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UIButton *)disAgreeButton {
    if (!_disAgreeButton) {
        _disAgreeButton = [[UIButton alloc] init];
        [_disAgreeButton setTitle:@"不同意并退出APP" forState:UIControlStateNormal];
        [_disAgreeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _disAgreeButton.backgroundColor = [UIColor clearColor];
        _disAgreeButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_disAgreeButton addTarget:self action:@selector(disAgreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disAgreeButton;
}

@end
