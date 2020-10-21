//
//  ImageNormalVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageNormalVC.h"
#import "SYImageBrowser.h"

@interface ImageNormalVC ()

@end

@implementation ImageNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"非循环广告轮播";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    // 网络图片
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
    [images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
    [images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    // 本地图片
//    NSArray *images = @[[UIImage imageNamed:@"01.jpeg"], [UIImage imageNamed:@"02.jpeg"], [UIImage imageNamed:@"03.jpeg"], [UIImage imageNamed:@"04.jpeg"], [UIImage imageNamed:@"05.jpeg"], [UIImage imageNamed:@"06.jpeg"]];
    // 本地图片
//    NSArray *images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    // 标题
    NSArray *titles = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 160.0)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片源
    imageView.images = images;
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollNormal;
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
    imageView.autoAnimation = NO;
    imageView.autoDuration = 1.2;
    // 图片浏览时才使用
    imageView.isBrowser = NO;
    // 滚动回调
    imageView.imageScrolled = ^(float contentOffX, NSInteger direction, BOOL isEnd){
        NSLog(@"contentOffX = %@, direction = %@, isEnd = %@", @(contentOffX), @(direction), @(isEnd));
    };
    // 图片点击
    imageView.imageSelected = ^(NSInteger index){
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index + 1)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    };
    // 数据刷新
    [imageView reloadData];
}

@end
