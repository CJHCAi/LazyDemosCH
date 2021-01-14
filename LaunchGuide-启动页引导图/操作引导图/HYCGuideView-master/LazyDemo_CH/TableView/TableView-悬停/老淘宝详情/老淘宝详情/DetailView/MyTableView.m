//
//  MyTableView.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/8.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "MyTableView.h"
#import "ToolHeader.h"
#import "TitlesView.h"
#import "BaseView.h"
@interface MyTableView ()<UIScrollViewDelegate>

@property (nonatomic, strong) TitlesView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabContentView;

@end


@implementation MyTableView

- (instancetype)initWithTabConfigArray:(NSArray *)tabConfigarray{
    if (self = [super initWithFrame:CGRectZero]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KTopBarHeight - KBottomBarHeight);
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i = 0; i < tabConfigarray.count ; i++) {
            NSDictionary *dic = tabConfigarray[i];
            [titleArray addObject:dic[@"title"]];
        }
        
        _tabTitleView = [[TitlesView alloc] initWithTitleArray:titleArray];
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger num) {
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(num * SCREEN_WIDTH, 0);
            }
        };
        [self addSubview:_tabTitleView];
        
        //下面的scrollView
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTitleView.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.contentSize = CGSizeMake(SCREEN_WIDTH * titleArray.count, 0);
        [self addSubview:_tabContentView];
        _tabContentView.delegate = self;
        
        
        //添加scrollView的内容视图
        for (int i = 0; i < tabConfigarray.count ; i++) {
            NSDictionary *dic = tabConfigarray[i];
            NSString * className = dic[@"view"];
            Class class = NSClassFromString(className);
            BaseView *contentView = [[class alloc] init];
            [contentView renderUIWithInfo:dic];
            [_tabContentView addSubview:contentView];
            
        }
        
    }
    return self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger pageNum = offSetX / SCREEN_WIDTH;
    [_tabTitleView setItemSelected:pageNum];
}

@end
