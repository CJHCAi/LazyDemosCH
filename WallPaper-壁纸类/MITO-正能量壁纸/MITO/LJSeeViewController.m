//
//  LJSeeViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/3.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJSeeViewController.h"
//#import <UIImageView+WebCache.h>

@interface LJSeeViewController ()

@end

@implementation LJSeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] init];
    if (self.imageUrl) {
     [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    }else{
     imageView.image =self.image;
    }
    imageView.userInteractionEnabled = YES;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
    NSArray *array = @[@"music",@"account_setting",@"aio_icons_freeaudio",@"aio_icons_togetherplay"];
    NSArray *titleArray = @[@"音乐",@"设置",@"通讯录",@"游戏"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        button.frame = CGRectMake((self.view.frame.size.width / 4 - 60) / 2 + i * (60 + (self.view.frame.size.width / 4 - 60)) , self.view.frame.size.height - 80, 60, 60);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [imageView addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 4 - 60) / 2 + i * (60 + (self.view.frame.size.width / 4 - 60))   , self.view.frame.size.height - 20,60,20)];
        label.text = titleArray[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [imageView addSubview:label];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.frame.size.height / 2 - 5, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"aio_face_delete"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backViewControllerWithSwipe:)];
    [imageView addGestureRecognizer:swipeRight];
    
}

- (void)backViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backViewControllerWithSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        //1.创建动画对象
        CATransition *transition = [CATransition animation];
        //2.设置动画时间
        transition.duration = 3;
        //3.设置动画类型
        //由第一个页面慢慢变淡道第二个页面
        //transition.type = @"oglFilp";
        //立方体翻转
        transition.type = @"push";
        
        //4.设置动画的方向，从那个方向出来
        transition.subtype = @"fromLeft";
        //5.将动画添加到UIView上
        [self.view.superview.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
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
