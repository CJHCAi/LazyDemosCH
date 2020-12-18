//
//  DTHomeScrollView.m
//  DTcollege
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ZDQK. All rights reserved.
//

#import "DTHomeScrollView.h"
#import "DTHomePageControl.h"
@interface DTHomeScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) DTHomePageControl *pageControl;
@property (nonatomic, strong) UIScrollView *upScrollView;
@end


@implementation DTHomeScrollView

-(instancetype)initWithFrame:(CGRect)frame viewsArray:(NSArray *)views{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.views = views;
        self.maxCount = 6;
        
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    //分页控件
    _pageControl = [[DTHomePageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20,self.frame.size.width, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = (self.views.count - 1) / self.maxCount + 1;
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    _pageControl.backgroundColor = [UIColor redColor];
    
    //滑动区域
    _upScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _pageControl.frame.size.height)];
    _upScrollView.delegate = self;
    _upScrollView.pagingEnabled = YES;
    _upScrollView.showsVerticalScrollIndicator = NO;
    _upScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_upScrollView];
    
    //分布按钮
    CGFloat margin = 20;
    CGFloat WH = (self.bounds.size.width -margin*4)/3;
    for (int i = 0; i < (self.views.count - 1) / self.maxCount + 1; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, _upScrollView.frame.size.height)];
        NSInteger index = self.maxCount;
        if ((self.views.count - i*6) <self.maxCount) {
            index = (self.views.count - i*self.maxCount);
        }
        
        for (int j = 0; j <index; j++) {
            int row = j/3;
            int col = j % 3;
            NSLog(@"row = %d",row);
            NSLog(@"col = %d",col);
            NSLog(@"btnHieght = %f",(bgView.frame.size.height / 2));
            
            UIButton *btn = self.views[i*self.maxCount+j];
            btn.frame = CGRectMake(margin + col * (WH + margin), row * (WH + margin), WH, WH);
            btn.tag = 100000 + i * self.maxCount + j;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
        }
        [_upScrollView addSubview:bgView];
        
    }
     _upScrollView.contentSize = CGSizeMake(self.frame.size.width * ((self.views.count - 1) / self.maxCount + 1), _upScrollView.frame.size.height);
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;  //计算这是第几页
    self.pageControl.currentPage = index;
    
}


- (void)btnAction:(UIButton *)btn{
    NSInteger index = btn.tag - 100000;
    if ([self.delegate respondsToSelector:@selector(buttonUpInsideWithView:withIndex:withView:)]) {
        [self.delegate buttonUpInsideWithView:btn withIndex:index withView:self];
    }
    
}
@end
