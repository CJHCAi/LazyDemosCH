//
//  NewVersionViewController.m
//  QQ空间
//
//  Created by 妖精的尾巴 on 15-8-24.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "NewVersionViewController.h"
#import "ViewController.h"
#define kIMGCount 4

@interface NewVersionViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic)UIScrollView* scroll;
@property(strong,nonatomic)UIPageControl* page;

@end

@implementation NewVersionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     *创建并添加UIScrollView
     */
    _scroll=[[UIScrollView alloc]init];
    _scroll.frame=self.view.bounds;
    [self.view addSubview:_scroll];
    
    CGFloat width=_scroll.frame.size.width;
    CGFloat height=_scroll.frame.size.height;
    for (int i=1; i<kIMGCount+1; i++) {
        UIImageView* imageView=[[UIImageView alloc]init];
        CGFloat imageX=(i-1)*width;
        CGFloat imageY=0;
        imageView.frame=CGRectMake(imageX, imageY, width, height);
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [_scroll addSubview:imageView];
        /**
         *在最后一张图片添加进入主页的按钮
         */
        if (i==kIMGCount){
            [self setupLastImageView:imageView];
        }
    }
    /*
     *添加UIPageControl，并设置相关属性
     */
    _page=[[UIPageControl alloc]initWithFrame:CGRectMake(100, 500, 100, 30)];
    _page.numberOfPages=kIMGCount;
    _page.pageIndicatorTintColor=[UIColor redColor];
    _page.currentPageIndicatorTintColor=[UIColor blueColor];
    [self.view addSubview:_page];
    
    /*
     *设置UIScrollView属性
     */
#warning UIScrollView必须指明的一个属性，没有指明，只显示第一张图片，而且不能交互，拖动图片
    _scroll.contentSize=CGSizeMake(kIMGCount*width, 0);
    _scroll.pagingEnabled=YES;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.bounces=NO;
    _scroll.delegate=self;
}
-(void)setupLastImageView:(UIImageView*)imageView
{
#warning 在imageView上添加按钮，需要开启用户交互功能，UIImageView这个功能默认关闭
    
    imageView.userInteractionEnabled=YES;
    
    UIButton* btn=[[UIButton alloc]init];
    btn.frame=CGRectMake(40, 435, 250, 75);
    btn.layer.cornerRadius=10;
    [btn setTitle:@"七夕，你的她（他）会在哪里" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpMainPage) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
}
#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    CGFloat offsetX=offset.x;
    int pageNum=(offsetX+0.5*_scroll.frame.size.width)/_scroll.frame.size.width;
    _page.currentPage=pageNum;
}
#pragma mark-btn的点击监听事件
-(void)jumpMainPage
{
    /**
     *拿到窗口的keyWindow，设置根控制器
     */
    UIWindow* window =[UIApplication sharedApplication].keyWindow;
    window.rootViewController=[[ViewController alloc]init];
    NSLog(@"欢迎来到空间首页");
}
-(void)dealloc
{
    NSLog(@"主人，今生有缘只见一次，来生再见");
}

@end
