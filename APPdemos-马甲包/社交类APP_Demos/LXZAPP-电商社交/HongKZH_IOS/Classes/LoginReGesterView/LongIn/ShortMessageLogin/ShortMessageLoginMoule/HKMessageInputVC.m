//
//  HKMessageInputVC.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMessageInputVC.h"
#import "HKMessageInputView.h"
@interface HKMessageInputVC ()
@property (nonatomic, strong)HKMessageInputView *messageInputView;
@end

@implementation HKMessageInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
-(void)setUI{
    self.navigationItem.title = @"登录乐小转";
    [self setShowCustomerLeftItem:YES];
    [self.view addSubview:self.messageInputView];
    [self.messageInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
}
-(HKMessageInputView *)messageInputView{
    if (!_messageInputView) {
        _messageInputView = [[HKMessageInputView alloc]init];
    }
    return _messageInputView;
}
@end
