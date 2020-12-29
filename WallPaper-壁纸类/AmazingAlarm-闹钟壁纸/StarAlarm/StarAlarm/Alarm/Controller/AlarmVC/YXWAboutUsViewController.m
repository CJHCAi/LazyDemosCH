//
//  YXWAboutUsViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/16.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "YXWAboutUsViewController.h"
@interface YXWAboutUsViewController ()

@end

@implementation YXWAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.title = @"关于我们";
    [self creatView];
    [self creatNav];
}

- (void)creatNav {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - 导航左侧返回按钮
-(void)leftButtonAction:(UIBarButtonItem *)barItem {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) creatView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
   backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.203825431034483];
    [self.view addSubview:backView];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height / 5 , 60 , 60)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [backView addSubview:logoImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, 20)];
    titleLabel.text = @"早晨给自己一个微笑 种上一天的阳光";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [backView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /4 - 14, self.view.frame.size.height / 2 - 20 , self.view.frame.size.width / 2 + 28,self.view.frame.size.height / 2 - 60)];
    
    contentLabel.text = @"早晨阳光灿烂照到了我的肩膀 窗外的小麻雀正在叽叽喳喳叫 关上闹钟我伸一个懒腰 我要对全世界说一声早上好 早晨阳光灿烂照到了我的肩膀 我要给全世界一个大大的拥抱 我对每个人都露出微笑 我对每个人都说早上好";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.font = [UIFont systemFontOfSize:16];
    
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    [paragraphStyle setLineSpacing:15];//调整行间距
    [contentLabel setAttributedText:attributedString];
    [contentLabel sizeToFit];
    [backView addSubview:contentLabel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
