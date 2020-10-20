//
//  ViewController.m
//  TypeView
//
//  Created by weizhongming on 2017/4/17.
//  Copyright © 2017年 航磊_. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "TypeView.h"
@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) TypeView *typeScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    NSArray *array = @[@"精选",@"电视剧",@"电影",@"这个分类特别长",@"短",@"VIP会员",@"喜剧",@"演唱会",@"网络电影"];

    self.typeScrollView = [[TypeView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    [self.view addSubview:self.typeScrollView];
    self.typeScrollView.resendBlock = ^(NSInteger page) {
        
        NSLog(@"点击了d第%ld个按钮",page);
    };
    
   //内容
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeScrollView.frame), CGRectGetWidth(self.typeScrollView.frame), self.view.frame.size.height - CGRectGetMaxY(self.typeScrollView.frame))];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"渐变图片.jpg"]];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *array.count, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    scrollView.contentOffset = CGPointMake(SCREEN_WIDTH *2, 0);
    
    self.typeScrollView.typeIndex = 2; //初始选中的第几个按钮
    self.typeScrollView.observerScrollView = scrollView; // 需要监听的scrollview（监听这个scrollview的滑动）
    _typeScrollView.lineView_Width = 50;
    _typeScrollView.button_Width = 10;
    [self.typeScrollView updateView:array]; // 刷新

}


// 滑动时
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
//    [self.typeScrollView lineViewFram:scrollView.contentOffset.x];
//}

// 结束滑动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.typeScrollView scrollViewNumber:scrollView.contentOffset.x /SCREEN_WIDTH];
}

// 开始滑动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.typeScrollView scrollViewBegin:scrollView.contentOffset.x];
}




@end
