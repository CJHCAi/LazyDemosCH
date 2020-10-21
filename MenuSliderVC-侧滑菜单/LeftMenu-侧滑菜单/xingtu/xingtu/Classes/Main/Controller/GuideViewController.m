//
//  GuideViewController.m
//  xingtu
//
//  Created by Wondergirl on 16/8/30.
//  Copyright © 2016年 🌹Wondergirl😄. All rights reserved.
//

#import "GuideViewController.h"
#import "mainTabBarController.h"
#import "AppDelegate.h"
//#import "JWTHomeViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    
    UIPageControl *_pageControl;
    
    
}

@property(nonatomic,weak) UIScrollView *scroll;



@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    
}
-(void)createScrollView{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scroll = scrollView;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    //是否分页
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    
    NSArray *images=@[@"guide0",@"guide1",@"guide3"];
    int imgX=0;
    int imgW=ScreenW;
    int imgH=ScreenH;
    for (int i = 0; i<images.count; i++) {
        
        imgX=i*imgW;
        
        UIImage *img=[UIImage imageNamed:images[i]];
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0, imgW, imgH)];
        
        imgView.image=img;
        
        [scrollView addSubview:imgView];
        
        if (i==images.count-1) {
            UIButton *btn=[UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn setTitle:@"立即体验" forState:(UIControlStateNormal)];
            btn.titleLabel.font =[UIFont systemFontOfSize:18];
            
            imgView.userInteractionEnabled=YES;
            [imgView addSubview:btn];
            
            CGFloat btnW=130;
            CGFloat btnH=45;
            CGFloat btnX=(imgW-btnW) *0.5;
            CGFloat btnY=imgH *0.8;
            btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 10.0;
            [btn.layer setBorderWidth:2.0]; //边框宽度
            
            [btn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
            [btn addTarget:self action:@selector(goMainController) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    
    scrollView.contentSize=CGSizeMake(images.count *imgW, 0);
    
    //创建pageControl
    _pageControl = [[UIPageControl alloc] init];
    //设置页数
    [_pageControl setNumberOfPages:3];
    //获取大小
    CGSize pageSize = [_pageControl sizeForNumberOfPages:3];
    //设置frame
    [_pageControl setFrame:CGRectMake((self.view.frame.size.width-pageSize.width)/2.0, self.view.frame.size.height-pageSize.height, pageSize.width, pageSize.height)];
    //设置选中小点颜色
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    //设置未选中小点颜色
    [_pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [self.view addSubview:_pageControl];
    
}

-(void)goMainController{
    
    //mainTabBarController *mainVc=[[mainTabBarController alloc] init];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    app.keyWindow.rootViewController=delegate.leftSlideVC;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前页数
    NSInteger currentP = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = currentP;
    
    
    
}

@end
