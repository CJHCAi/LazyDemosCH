//
//  HKSelectViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectViewController.h"

@interface HKSelectViewController ()
@property (nonatomic, strong)UIView *titleTool;
@property (nonatomic, strong)UILabel *toolName;
@end

@implementation HKSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)setUI{
    [self.view addSubview:self.titleTool];
    [self.titleTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.view).offset(180);
    }];
}
-(UIView *)titleTool{
    if (!_titleTool) {
        _titleTool = [[UIView alloc]init];
        [_titleTool addSubview:self.toolName];
    }
    return _titleTool;
}
-(UILabel *)toolName{
    if (!_toolName) {
        _toolName = [[UILabel alloc]init];
        _toolName.font = [UIFont systemFontOfSize:15];
        _toolName.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return _toolName;
}
@end
