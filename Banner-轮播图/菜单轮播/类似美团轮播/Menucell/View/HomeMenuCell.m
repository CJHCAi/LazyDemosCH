//
//  HomeMenuCell.m
//  meituan
//
//  Created by lujh on 15/6/30.
//  Copyright (c) 2015年 lujh. All rights reserved.
//
// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#define navigationBarColor RGB(33, 192, 174)

#import "HomeMenuCell.h"
@interface HomeMenuCell ()<UIScrollViewDelegate>

@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.menuArray = [NSMutableArray array];
        
        self.menuArray = menuArray;
        
        // 初始化cell布局
        [self setUpSubViews];
        
    }
    return self;
}

#pragma mark -初始化cell布局
- (void)setUpSubViews {

    // 轮播图第一页
    _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
    
    // 轮播图第二页
    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(screen_width, 0, screen_width, 160)];
    
    // UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 180)];
    scrollView.contentSize = CGSizeMake(2*screen_width, 180);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [scrollView addSubview:_backView1];
    [scrollView addSubview:_backView2];
    [self addSubview:scrollView];
    
    //创建8个view
    for (int i = 0; i < 16; i++) {
        if (i < 4) {
            CGRect frame = CGRectMake(i*screen_width/4, 0, screen_width/4, 80);
            NSString *title = [_menuArray[i] objectForKey:@"title"];
            NSString *imageStr = [_menuArray[i] objectForKey:@"image"];
            JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
            btnView.tag = 10+i;
            [_backView1 addSubview:btnView];
            
            // 点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneView:)];
            [btnView addGestureRecognizer:tap];
            
        }else if(i<8){
            CGRect frame = CGRectMake((i-4)*screen_width/4, 80, screen_width/4, 80);
            NSString *title = [_menuArray[i] objectForKey:@"title"];
            NSString *imageStr = [_menuArray[i] objectForKey:@"image"];
            JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
            btnView.tag = 10+i;
            [_backView1 addSubview:btnView];
            
            // 点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneView:)];
            [btnView addGestureRecognizer:tap];
        }else if(i < 12){
            CGRect frame = CGRectMake((i-8)*screen_width/4, 0, screen_width/4, 80);
            NSString *title = [_menuArray[i] objectForKey:@"title"];
            NSString *imageStr = [_menuArray[i] objectForKey:@"image"];
            JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
            btnView.tag = 10+i;
            [_backView2 addSubview:btnView];
            
            // 点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneView:)];
            [btnView addGestureRecognizer:tap];
        }else{
            CGRect frame = CGRectMake((i-12)*screen_width/4, 80, screen_width/4, 80);
            NSString *title = [_menuArray[i] objectForKey:@"title"];
            NSString *imageStr = [_menuArray[i] objectForKey:@"image"];
            JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
            btnView.tag = 10+i;
            [_backView2 addSubview:btnView];
            
            // 点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneView:)];
            [btnView addGestureRecognizer:tap];
        }
    }
    
    //UIPageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((screen_width -97)/2, 160, 0, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 2;
    [self addSubview:_pageControl];
    
    
    [_pageControl setCurrentPageIndicatorTintColor:navigationBarColor];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
}

#pragma mark -手势点击事件

-(void)tapOneView:(UITapGestureRecognizer *)sender{
    
    
    if ([self.onTapBtnViewDelegate respondsToSelector:@selector(OnTapBtnView:)]) {
        
        [self.onTapBtnViewDelegate OnTapBtnView:sender];
    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
    
}


@end
