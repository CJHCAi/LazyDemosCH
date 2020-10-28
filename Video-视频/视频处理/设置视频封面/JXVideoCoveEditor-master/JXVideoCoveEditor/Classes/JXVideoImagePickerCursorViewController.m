//
//  JXVideoImagePickerCursorViewController.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImagePickerCursorViewController.h"

@interface JXVideoImagePickerCursorViewController ()


@property(nonatomic, strong) UIView *line;

@property(nonatomic, strong) UIView *cursorView;

@end

@implementation JXVideoImagePickerCursorViewController

#pragma mark - laze loading

- (UIView *)cursorView{
    if (_cursorView == nil) {
        _cursorView = [[UIView alloc]init];
        _cursorView.backgroundColor = [UIColor whiteColor];
        _cursorView.alpha = .6;
    }
    return _cursorView;
}
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor blueColor];
        _line.alpha = .6;
    }
    return _line;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI{
    [self.view addSubview:self.cursorView];
    [self.cursorView addSubview:self.line];
    
    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    JXWeakSelf(self);
    [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
        JXStrongSelf(self);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(15, self.view.bounds.size.height));
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        JXStrongSelf(self);
        make.centerX.equalTo(self.cursorView);
        make.size.mas_equalTo(CGSizeMake(1, self.view.bounds.size.height));
        make.bottom.equalTo(self.cursorView.mas_bottom).offset(0);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
