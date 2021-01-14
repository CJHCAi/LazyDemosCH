//
//  ViewController.m
//  StartUp_HomePage_demo
//
//  Created by Derek on 2017/4/29.
//  Copyright © 2017年 www.ioslover.club. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}
@end

@implementation ViewController

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    //判断是不是第一次启动软件，如果是，那么显示启动欢迎页
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    if ([userDefaults objectForKey:@"FirstLoad"]==nil) {
        [userDefaults setBool:NO forKey:@"FirstLoad"];
        [self setupScrollView];
        [self setupPageControl];
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor=[UIColor redColor];
    
    
    
}

- (void)setupScrollView{
    CGRect r = [[UIScreen mainScreen] bounds];
    scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delegate =self;
    [self.view addSubview:scrollView];
    //关闭水平方向上的滚动条
    scrollView.showsHorizontalScrollIndicator =NO;
    //是否可以整屏滑动
    scrollView.pagingEnabled =YES;
    scrollView.tag =200;
    scrollView.bounces=NO;
    scrollView.contentSize =CGSizeMake(r.size.width *3, [UIScreen mainScreen].bounds.size.height);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(r.size.width * i,0,r.size.width, [UIScreen mainScreen].bounds.size.height)];
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"pic_%d", i+1] ofType:@"png"]];
        [scrollView addSubview:imageView];
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor whiteColor];
    [button setTitle:@"开始体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame=CGRectMake(r.size.width*2+r.size.width/2-50, [UIScreen mainScreen].bounds.size.height -80, 100, 30);
    [button addTarget:self action:@selector(showDocList) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    //button.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 20);
    [scrollView addSubview:button];
    
}
//从ViewController移除scrollView和pageControl
-(void)showDocList{
//    WelcomeViewController *mainList=[WelcomeViewController new];
//    [self presentViewController:mainList animated:NO completion:nil];
    
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
}

- (void)setupPageControl
{
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -40, [UIScreen mainScreen].bounds.size.width, 20)];
    pageControl.tag =100;
    //设置表示的页数
    pageControl.numberOfPages =3;
    //设置选中的页数
    pageControl.currentPage =0;
    //设置未选中点的颜色
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //设置选中点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //添加响应事件
    [pageControl addTarget:self action:@selector(handlePageControl:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    UIPageControl *pagControl = (UIPageControl *)[self.view viewWithTag:100];
    pagControl.currentPage = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
}

- (void)handlePageControl:(UIPageControl *)pageControl

{
    //切换pageControl .对应切换scrollView不同的界面
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:200];
    //
    [scrollView setContentOffset:CGPointMake(320 * pageControl.currentPage,0)animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
