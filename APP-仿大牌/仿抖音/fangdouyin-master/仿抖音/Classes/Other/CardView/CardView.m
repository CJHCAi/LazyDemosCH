//
//  CardView.m
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "CardView.h"
#import <Masonry/Masonry.h>
#import "CardModel.h"
#import "CardCell.h"

@interface CardView()<UIScrollViewDelegate>
@property(nonatomic,assign)Class cellCls;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray<CardCell*> *cells;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)NSInteger count;
@end

@implementation CardView

#pragma mark - 📓public method
-(void)reloadData
{
    NSInteger count = [self.dataSource numberOfSectionsInCardView:self];
    self.count = count;
    
    [self reloadViews];
    
    if ([self.delegate respondsToSelector:@selector(cardView:didEndscrollIndex:cell:)]) {
        [self.delegate cardView:self didEndscrollIndex:0 cell:self.cells[0]];
    }
    
}

#pragma mark - 📒life cycle
-(instancetype)initWithCellCls:(Class)cellCls
{
    self = [super init];
    if (self) {
        self.cellCls = cellCls;
        [self scrollView];
        [self loadSubViews];
    }
    return self;
}

#pragma mark - 📕delegate
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0 && self.currentIndex>0) {
        scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(scrollView.bounds));
        self.currentIndex--;
        
        CardCell *cell = self.cells.lastObject;
        [self.cells removeLastObject];
        [self.cells insertObject:cell atIndex:0];
        CardModel *model = [self.dataSource cardView:self cellForRowAtIndexPath:self.currentIndex];
        cell.model = model;
        [self reloadLayout];
    }
    
    if (offsetY >= CGRectGetHeight(scrollView.bounds)*2 && self.currentIndex+3<self.count) {
        scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(scrollView.bounds));
        self.currentIndex++;
        
        CardCell *cell = self.cells.firstObject;
        [self.cells removeObjectAtIndex:0];
        [self.cells addObject:cell];
        CardModel *model = [self.dataSource cardView:self cellForRowAtIndexPath:self.currentIndex+2];
        cell.model = model;
        [self reloadLayout];
    }
    offsetY = scrollView.contentOffset.y;
    NSInteger index = offsetY/CGRectGetHeight(scrollView.bounds) + self.currentIndex;
    if ([self.delegate respondsToSelector:@selector(cardView:didEndscrollIndex:cell:)]) {
        [self.delegate cardView:self didEndscrollIndex:index cell:self.cells[index-self.currentIndex]];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSInteger index = offsetY/CGRectGetHeight(scrollView.bounds) + self.currentIndex;
    
    if ([self.delegate respondsToSelector:@selector(cardView:willBeginScrollIndex:cell:)]) {
        [self.delegate cardView:self willBeginScrollIndex:index cell:self.cells[index-self.currentIndex]];
    }
}

#pragma mark - 📗event response

#pragma mark - 📘private method
-(void)loadSubViews
{
    CardCell *view1 = (CardCell*)[[self.cellCls alloc] init];
    [self.scrollView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    [self.cells addObject:view1];
    
    CardCell *view2 = (CardCell*)[[self.cellCls alloc] init];
    [self.scrollView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    [self.cells addObject:view2];
    
    CardCell *view3 = (CardCell*)[[self.cellCls alloc] init];
    [self.scrollView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom);
        make.left.right.bottom.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    [self.cells addObject:view3];
    
}

-(void)reloadLayout
{
    CardCell *view1 = self.cells[0];
    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    
    CardCell *view2 = self.cells[1];
    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
    
    CardCell *view3 = self.cells[2];
    [view3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom);
        make.left.right.bottom.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
}

-(void)reloadViews
{
    for (int i=0; i<3; i++) {
        CardModel *model = [self.dataSource cardView:self cellForRowAtIndexPath:self.currentIndex+i];
        CardCell *cell = self.cells[i];
        cell.model = model;
    }
}

#pragma mark - 📙getter and setter
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
//        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _scrollView;
}

-(NSMutableArray<CardCell *> *)cells
{
    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}

@end
