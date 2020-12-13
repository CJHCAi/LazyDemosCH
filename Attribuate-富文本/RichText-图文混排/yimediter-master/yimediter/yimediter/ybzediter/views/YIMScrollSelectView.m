//
//  YIMScrollSelectView.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMScrollSelectView.h"

@interface YIMScrollSelectItemView : UIView
@property(nonatomic,strong)UIView *userView;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)void(^clickBlock)(YIMScrollSelectItemView* itemView);
@end
@implementation YIMScrollSelectItemView
-(instancetype)initWithUserView:(UIView*)userView isSelect:(BOOL)selected{
    if(self = [super init]){
        userView.frame = self.bounds;
        userView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:userView];
        self.userView = userView;
        self.selected = selected;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)click:(id)sender{
    if(self.clickBlock)
        self.clickBlock(self);
}
@end


@interface YIMScrollSelectView()<UIScrollViewDelegate>

/**当前选择的index*/
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray<YIMScrollSelectItemView*>* itemViews;
@property(nonatomic,strong)CAGradientLayer *maskLayer;

@end

@implementation YIMScrollSelectView

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.itemViews = [NSMutableArray array];
        [self setUp];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.itemViews = [NSMutableArray array];
    [self setUp];
}
-(void)layoutSubviews{
    [self layoutItemViews];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview)
        [self reloadData];
}

#pragma -mark get set
/**设置当前选中index时*/
-(void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex == currentIndex) {
        return;
    }
    //旧的选中位置的Selected View
    YIMScrollSelectItemView *oldSelectedView = self.itemViews[_currentIndex];
    //旧的选中位置的Normal View，将替换Selected View
    YIMScrollSelectItemView *oldNormalView = [self createItemViewAtIndex:_currentIndex isSelected:false];
    
    //新的选中位置的Normal View
    YIMScrollSelectItemView *newNormalView = self.itemViews[currentIndex];
    //新的选中位置的Selected View，将替换Normal View
    YIMScrollSelectItemView *newSelectedView = [self createItemViewAtIndex:currentIndex isSelected:true];
    
    [self replaceView:oldSelectedView new:oldNormalView];
    [self replaceView:newNormalView new:newSelectedView];
    
    //如果需要动画来切换View
    if ([self.delegate respondsToSelector:@selector(animation:oldSelectedView:oldNormalView:)]) {
        [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.delegate animation:self oldSelectedView:oldSelectedView.userView oldNormalView:newNormalView.userView];
        }completion:^(BOOL finished) {
            [oldSelectedView removeFromSuperview];
            [newNormalView removeFromSuperview];
            [self.scrollView addSubview:oldNormalView];
            [self.scrollView addSubview:newSelectedView];
        }];
    }else{
        [oldSelectedView removeFromSuperview];
        [newNormalView removeFromSuperview];
        [self.scrollView addSubview:oldNormalView];
        [self.scrollView addSubview:newSelectedView];
    }
    _currentIndex = currentIndex;
}


#pragma -mark private methods
/**替换两个View*/
-(void)replaceView:(YIMScrollSelectItemView*)oldView new:(YIMScrollSelectItemView*)newView{
    newView.frame = oldView.frame;
    [self.itemViews replaceObjectAtIndex:[self.itemViews indexOfObject:oldView] withObject:newView];
}
/**创建指定位置的itemView*/
-(YIMScrollSelectItemView*)createItemViewAtIndex:(NSInteger)index isSelected:(BOOL)selected{
    UIView *contentView = nil;
    if (selected) {
        contentView = [self.dataSource selectedView:self atIndex:index];
    }else{
        contentView = [self.dataSource normalView:self atIndex:index];
    }
    YIMScrollSelectItemView *itemView = [[YIMScrollSelectItemView alloc]initWithUserView:contentView isSelect:selected];
    __weak typeof(self) weakSelf = self;
    [itemView setClickBlock:^(YIMScrollSelectItemView* view){
        [weakSelf selectedIndex:index animation:true];
        if([self.delegate respondsToSelector:@selector(YIMScrollSelectView:didSelectedIndex:)]){
            [self.delegate YIMScrollSelectView:self didSelectedIndex:index];
        }
    }];
    return itemView;
}
/**初始化*/
-(void)setUp{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    scrollView.frame = self.bounds;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.showsHorizontalScrollIndicator = false;
    
    //遮罩使两边有点透明效果
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[
                          (__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor,
                          (__bridge id)[UIColor clearColor].CGColor
                          ];
    maskLayer.locations = @[@0, @0.25, @0.5, @0.75, @1];
    maskLayer.startPoint = CGPointMake(0, 0);
    maskLayer.endPoint = CGPointMake(1, 0);
    self.layer.mask = maskLayer;
    
    self.maskLayer = maskLayer;
    self.scrollView = scrollView;
}
/**布局Item视图*/
-(void)layoutItemViews{
    CGSize itemSize = [self itemSize];
    //item的Y坐标
    CGFloat yPoint = (CGRectGetHeight(self.frame) - itemSize.height)/2;
    
    //布局所有item，x坐标不是从0开始，而是从第一个元素的中心点开始
    for (NSInteger index = 0,xPoint = -itemSize.width/2; index < _itemViews.count; index++,xPoint += itemSize.width) {
        _itemViews[index].frame = CGRectMake(trunc(xPoint * 2) / 2, trunc(yPoint * 2) / 2, itemSize.width, itemSize.height);
    }
    self.maskLayer.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.itemViews.lastObject.frame) - itemSize.width/2, CGRectGetHeight(self.frame));
    //scrollView两边留空，使scrollView选择最边上的item时保持剧中
    self.scrollView.contentInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.frame)/2, 0, CGRectGetWidth(self.frame)/2);
    [self.scrollView setContentOffset:CGPointMake(CGRectGetMidX(self.itemViews[self.currentIndex].frame) - CGRectGetWidth(self.bounds) / 2, 0) animated:true];
}
-(void)selectedIndex:(NSInteger)index animation:(BOOL)animation{
    CGFloat offX =  self.itemViews[index].frame.origin.x - CGRectGetWidth(self.scrollView.frame)/2 + CGRectGetWidth(self.itemViews[index].frame)/2;
    self.currentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(offX, self.scrollView.contentOffset.y) animated:animation];
}
/**刷新数据*/
-(void)reloadData{
    NSInteger count = [self.dataSource numberOfItems:self];
    [self.itemViews removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (count <= 0) {
        self.scrollView.contentSize = CGSizeZero;
        return;
    }
    for (NSInteger i = 0; i < count; i++) {
        YIMScrollSelectItemView *itemView;
        if (i == self.currentIndex) {
            itemView = [self createItemViewAtIndex:i isSelected:true];
        }else{
            itemView = [self createItemViewAtIndex:i isSelected:false];
        }
        [self.scrollView addSubview:itemView];
        [self.itemViews addObject:itemView];
    }
    [self layoutItemViews];
}
/**滚动结束时，确定选择item，更新滚动位置使选中item剧中*/
-(void)scrollViewEnd{
    CGPoint centerLocation = CGPointZero;
    centerLocation.x = self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds) / 2;
    centerLocation.y = CGRectGetMidY(self.bounds);
    
    for (NSInteger index = 0; index < self.itemViews.count; index++) {
        UIView *itemView = self.itemViews[index];
        if ((index == 0 && centerLocation.x < CGRectGetMinX(itemView.frame)) ||
            (index == self.itemViews.count - 1 && centerLocation.x > CGRectGetMaxX(itemView.frame)) ||
            CGRectContainsPoint(itemView.frame, centerLocation)) {
            if (index != self.currentIndex) {
                self.currentIndex = index;
                if([self.delegate respondsToSelector:@selector(YIMScrollSelectView:didSelectedIndex:)]){
                    [self.delegate YIMScrollSelectView:self didSelectedIndex:index];
                }
            }
            [self.scrollView setContentOffset:CGPointMake(CGRectGetMidX(itemView.frame) - CGRectGetWidth(self.bounds) / 2, 0) animated:true];
            break;
        }
    }
}
-(CGSize)itemSize{
    //item的大小 从代理获得，如果代理没有提供 默认显示5个，高度和self相同
    CGSize itemSize = CGSizeZero;
    if([self.dataSource respondsToSelector:@selector(itemSize:)]){
        itemSize = [self.dataSource itemSize:self];
    }else{
        itemSize = CGSizeMake(CGRectGetWidth(self.frame)/5,CGRectGetHeight(self.frame));
    }
    return itemSize;
}
#pragma -mark delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(YIMScrollSelectView:didScrollSelected:)]) {
        CGFloat xPoint = scrollView.contentOffset.x + scrollView.contentInset.left;
        CGFloat itemWidth = self.itemViews.firstObject.frame.size.width;
        NSInteger index =MIN(self.itemViews.count-1, MAX(0,(xPoint-self.itemViews.firstObject.frame.origin.x)/itemWidth));
        if([self.delegate YIMScrollSelectView:self didScrollSelected:index]){
            self.currentIndex = index;
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewEnd];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEnd];
}

@end
