//
//  HKTitleViewSearchViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTitleViewSearchViewController.h"

@interface HKTitleViewSearchViewController ()

@end

@implementation HKTitleViewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self setSearchUI];
}
-(void)setSearchUI{
    [self.view addSubview:self.nabarView];
    [self.nabarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}
- (BackSearchNabarView *)nabarView
{
    if(_nabarView == nil)
    {
        _nabarView = [[ BackSearchNabarView alloc]init];
        _nabarView.delegate = self;
    }
    return _nabarView;
}


@end
