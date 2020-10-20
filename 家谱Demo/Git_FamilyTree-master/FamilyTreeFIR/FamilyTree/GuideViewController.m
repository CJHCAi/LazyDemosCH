//
//  GuideViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/2.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "GuideViewController.h"
#import "RootTabBarViewController.h"
#import "LoginViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
/** 滚动视图*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 分页控件*/
@property (nonatomic, strong) UIPageControl *pageControl;
/** 开始体验*/
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0).rightSpaceToView(self.view,0);
    [self.view addSubview:self.pageControl];
    self.pageControl.sd_layout.centerXEqualToView(self.view).heightIs(30).widthIs(120).bottomSpaceToView(self.view,40);
    NSArray *imageArr = @[MImage(@"xunqin"),MImage(@"wenzu"),MImage(@"xiupu")];
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width*i, 0, Screen_width, Screen_height)];
        imageView.image = imageArr[i];
        [self.scrollView addSubview:imageView];
        if (i == 2) {
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:self.startBtn];
            self.startBtn.sd_layout.centerXEqualToView(imageView).heightIs(30).widthIs(120).bottomSpaceToView(imageView,100);
        }
    }
    
}

#pragma mark - 点击事件
-(void)clickToStart{
    MYLog(@"开始体验");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x)/(Screen_width);
    self.pageControl.currentPage = index;
}

#pragma  mark - lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.contentSize = CGSizeMake(Screen_width*3, Screen_height);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"de5b59"];
        _pageControl.pageIndicatorTintColor  = [UIColor colorWithHexString:@"919192"];
    }
    return _pageControl;
}

-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [[UIButton alloc]init];
//        [_startBtn setTitle:@"开始体验" forState:UIControlStateNormal];
//        _startBtn.backgroundColor = [UIColor clearColor];
//        _startBtn.layer.borderWidth = 1;
//        _startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_startBtn setBackgroundImage:MImage(@"lijitiyan") forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(clickToStart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

@end
