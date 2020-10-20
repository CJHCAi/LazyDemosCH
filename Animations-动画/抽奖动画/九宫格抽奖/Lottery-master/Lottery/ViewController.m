//
//  ViewController.m
//  Lottery
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 xiaohaodong. All rights reserved.
// 如果在使用中遇到什么问题，请发送邮件到 “woaichunchunma2010@163.com”进行交流
// QQ交流群：594257383

#import "ViewController.h"
#import "LuckView.h"

@interface ViewController ()<LuckViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLuckView];
}


- (void)createLuckView {
    LuckView *luckView = [[LuckView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth) * 0.5, ScreenWidth, ScreenWidth)];
    
    //网络图片地址
    luckView.imageArray = [@[@"http://pic48.nipic.com/file/20140912/7487939_223919315000_2.jpg",@"http://pic.58pic.com/58pic/13/60/97/48Q58PIC92r_1024.jpg",@"http://pic.jj20.com/up/allimg/911/0P316142450/160P3142450-4.jpg",@"http://img.taopic.com/uploads/allimg/140322/235058-1403220K93993.jpg",@"http://pic.58pic.com/58pic/15/36/02/06Q58PICH7S_1024.jpg",@"http://scimg.jb51.net/allimg/150713/14-150G31G222950.jpg",@"http://scimg.jb51.net/allimg/150618/14-15061Q13224641.jpg",@"http://pic.58pic.com/58pic/14/32/29/358PICv58PICx6y_1024.jpg"]mutableCopy];
    //指定抽奖结果,对应数组中的元素
    luckView.stopCount = arc4random()%luckView.imageArray.count;
    
    
    //block用法获取结果
    [luckView getLuckResult:^(NSInteger result) {
        NSLog(@"抽到了第%ld个",result);
    }];
    //block用法监听点击
    [luckView getLuckBtnSelect:^(UIButton *btn) {
        NSLog(@"点击了数组中的第%ld个元素",btn.tag);
    }];
    NSLog(@"stopCount = %d",luckView.stopCount);
    //设置代理
    //luckView.delegate = self;
    [self.view addSubview:luckView];
}


#pragma mark - LuckViewDelegate
/**
 *  中奖
 *
 *  @param count 返回结果数组的下标
 */
- (void)luckViewDidStopWithArrayCount:(NSInteger)count {
    NSLog(@"抽到了第%ld个",count);
}


/**
 *  点击了数组中的第几个元素
 *
 *  @param btn
 */
- (void)luckSelectBtn:(UIButton *)btn {
    NSLog(@"点击了数组中的第%ld个元素",btn.tag);
    
}




@end
