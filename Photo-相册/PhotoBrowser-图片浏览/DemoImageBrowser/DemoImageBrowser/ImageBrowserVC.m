//
//  ImageBrowserVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/18.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ImageBrowserVC.h"
#import "SYImageBrowser.h"

@interface ImageBrowserVC ()

@end

@implementation ImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"图片浏览";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setUI
{
    NSArray *images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
//    images = @[@"01.jpeg"];
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, (self.view.frame.size.height - 64.0))];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.images = images;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.pageControlType = UIImagePageLabel;
    imageView.pageIndex = 3;
    imageView.hiddenWhileSinglePage = YES;
    imageView.enableWhileSinglePage = NO;
    [imageView reloadData];
}

@end
