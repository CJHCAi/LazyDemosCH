//
//  ViewController.m
//  ValidateCodeView
//
//  Created by zhuming on 16/3/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import "ValidateCodeView.h"


@interface ViewController ()<ValidateCodeDelegate>
@property (weak, nonatomic) IBOutlet UIView *validateCode;
/**
 *  验证码控件
 */
@property (nonatomic,strong)ValidateCodeView *vaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化 验证码控件
    self.vaView = [[ValidateCodeView alloc] initWithFrame:CGRectMake(0, 0, self.validateCode.frame.size.width, self.validateCode.frame.size.height) timerCount:10];
    [self.vaView canGetYzm:YES]; // 控件可以点击
    self.vaView.delegate = self; // 管理代理
    [self.validateCode addSubview:self.vaView];
}
/**
 *  开始倒计时
 */
- (void)startTimeCount{
    NSLog(@"开始倒计时");
    [self.vaView canGetYzm:NO];

}
/**
 *  倒计时结束
 */
- (void)endTimeCount{
    NSLog(@"结束倒计时");
    [self.vaView canGetYzm:YES];
}
/**
 *  跳转到下一界面
 *
 *  @param sender sender description
 */
- (IBAction)nextBtnClick:(UIButton *)sender {
    SecondViewController *sVc = [[SecondViewController alloc] init];
    [self presentViewController:sVc animated:YES completion:nil];
}
/**
 *  视图将要消失
 *
 *  @param animated animated description
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.vaView reset];
}



@end
