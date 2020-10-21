//
//  ImageRunloopVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageRunloopVC.h"
#import "SYImageBrowser.h"

@interface ImageRunloopVC ()

@end

@implementation ImageRunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"循环广告轮播";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    [self runloopUI];
    [self runloopAutoUI];
}

- (void)runloopUI
{
    // 网络图片
    NSArray *images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    // 标题
    NSArray *titles = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 160.0)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片源
    imageView.images = images;
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollLoop;
    // 图片显示模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 标题标签
    imageView.titles = titles;
    imageView.showTitle = YES;
    imageView.titleLabel.textColor = [UIColor redColor];
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 页签-label UILabelControlType
    imageView.pageControlType = UIImagePageControl;
    imageView.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView.pageLabel.textColor = [UIColor redColor];
    // 切换按钮
    imageView.showSwitch = YES;
    // 自动播放
    imageView.autoAnimation = NO;
    imageView.autoDuration = 1.2;
    // 图片点击
    imageView.imageSelected = ^(NSInteger index){
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    };
    //
    imageView.imageBrowserDidScroll = ^(NSInteger index) {
        NSLog(@"block index = %@", @(index));
    };
    // 数据刷新
    [imageView reloadData];
}

- (void)runloopAutoUI
{
    // 网络图片
//    NSArray *images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    NSArray *images = @[@"01.jpeg"];
    // 标题
    NSArray *titles = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 160.0)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片源
    imageView.images = images;
    //
    imageView.enableWhileSinglePage = NO;
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollLoop;
    // 图片显示模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 标题标签
    imageView.titles = titles;
    imageView.showTitle = YES;
    imageView.titleLabel.textColor = [UIColor redColor];
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 页签-label 
    imageView.pageControlType = UIImagePageControl;
    imageView.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView.pageLabel.textColor = [UIColor redColor];
    // 切换按钮
    imageView.showSwitch = YES;
    // 自动播放
    imageView.autoAnimation = YES;
    imageView.autoDuration = 2.0;
    // 图片点击
    imageView.imageSelected = ^(NSInteger index){
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    };
    //
    imageView.imageBrowserDidScroll = ^(NSInteger index) {
        NSLog(@"block index = %@", @(index));
    };
    // 数据刷新
    [imageView reloadData];
}

@end
