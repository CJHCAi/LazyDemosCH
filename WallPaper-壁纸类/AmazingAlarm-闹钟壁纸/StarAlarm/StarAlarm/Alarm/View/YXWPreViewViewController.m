//
//  YXWPreViewViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWPreViewViewController.h"

@interface YXWPreViewViewController ()

@end

@implementation YXWPreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self creatInterface];
    
}

#pragma mark - 显示的壁纸
-(void)creatInterface {
    //展示的壁纸
    UIImageView *preImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    preImageView.image = [UIImage imageNamed:self.imageName];
    [self.view addSubview:preImageView];
    
    UIView *preView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 135, self.view.frame.size.width, 135)];
    
    preView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.198006465517241];
    
    [self.view addSubview:preView];
    //返回上一页
    UIButton *fhButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fhButton.frame = CGRectMake(self.view.frame.size.width / 2 - 84,self.view.frame.size.height - 130 ,40 ,40);
    [fhButton setImage:[[UIImage imageNamed:@"guanbi.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [fhButton addTarget:self action:@selector(fhButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fhButton];
    //button下文字
    UILabel *fhLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 -80, self.view.frame.size.height - 85, 40, 30)];
    fhLabel.text = @"取消";
    fhLabel.textColor = [UIColor whiteColor];
    fhLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:fhLabel];
    
    
    //使用button
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeSystem];
    useButton.frame = CGRectMake(self.view.frame.size.width / 2 + 50, self.view.frame.size.height - 130, 40, 40);
    [useButton setImage:[[UIImage imageNamed:@"use.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [useButton addTarget:self action:@selector(useButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
    
    UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 55, self.view.frame.size.height - 85, 40, 30)];
    useLabel.text = @"使用";
    useLabel.textColor = [UIColor whiteColor];
    useLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:useLabel];
    
    
}

#pragma mark - 返回
-(void)fhButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击变幻背景
-(void)useButtonAction:(UIButton *)sender {
    //通知中心
    [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:self.imageName];
    //存本地
    [[NSUserDefaults standardUserDefaults] setObject:self.imageName forKey:@"image"];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
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
