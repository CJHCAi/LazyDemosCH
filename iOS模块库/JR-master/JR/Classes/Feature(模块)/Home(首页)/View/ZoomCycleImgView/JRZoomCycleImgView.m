//
//  LTZoomCycleImgView.m
//  旅途逸居
//
//  Created by 张骏 on 17/5/5.
//  Copyright © 2017年 武汉国扬科技有限公司. All rights reserved.
//

#define JRZoomCycleImgCellReusedId @"zoomCycleImgCellReusedId"

#import "JRZoomCycleImgView.h"
#import "JRZoomCycleImgCell.h"

@interface JRZoomCycleImgView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation JRZoomCycleImgView

#pragma mark ---lifeCycle---
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupCollectionView];
    }
    return self;
}


#pragma mark ---public---
- (void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    
    if (picArray.count) {
        [_collectionView reloadData];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:500 * picArray.count inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        _currentIndex = 500 * picArray.count - 1;
    }
}


#pragma mark ---private---
- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.layer.masksToBounds = NO;
    
    [_collectionView registerClass:[JRZoomCycleImgCell class] forCellWithReuseIdentifier:JRZoomCycleImgCellReusedId];
    
    [self addSubview:_collectionView];
}


- (void)adjustImgTransformWithOffsetY:(CGFloat)offsetY{
    CGFloat index = (offsetY + 3 * JRPadding) / (JRScreenWidth - 6 * JRPadding);
    CGFloat deltaIndex = index - _currentIndex;
    CGFloat zoomScale = 1 - fabs(deltaIndex - 1) * 0.15;
    
    CGFloat leftIndex = (offsetY + 3 * JRPadding - (JRScreenWidth - 6 * JRPadding)) / (JRScreenWidth - 6 * JRPadding);
    CGFloat leftDeltaIndex = leftIndex - _currentIndex;
    CGFloat leftZoomScale = fabs(leftDeltaIndex) * 0.15 + 0.85;
    
    CGFloat rightIndex = (offsetY + 3 * JRPadding + (JRScreenWidth - 6 * JRPadding)) / (JRScreenWidth - 6 * JRPadding);
    CGFloat rightDeltaIndex = rightIndex - _currentIndex;
    CGFloat rightZoomScale = fabs(rightDeltaIndex - 2) * 0.15 + 0.85;
    
    [_collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger item = [[_collectionView indexPathForCell:obj] item];
        if (item == _currentIndex + 1) { // 中间一个
            obj.transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
        } else if (item == _currentIndex) { // 左边一个
            obj.transform = CGAffineTransformMakeScale(leftZoomScale, leftZoomScale);
        } else if (item == _currentIndex + 2){ // 右边一个
            obj.transform = CGAffineTransformMakeScale(rightZoomScale, rightZoomScale);
        }
    }];
}


#pragma mark ---UICollectionViewDelegate---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1000 * _picArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JRZoomCycleImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JRZoomCycleImgCellReusedId forIndexPath:indexPath];
    cell.imgView.image = _picArray[indexPath.item % _picArray.count];
    cell.transform = indexPath.item == _picArray.count * 500 ? CGAffineTransformMakeScale(1, 1) : CGAffineTransformMakeScale(0.85, 0.85);
    
    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(JRScreenWidth - 6 * JRPadding, JRZoomCycleImgViewHeight);
}


//纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item % _picArray.count == 0) {
        _clicked();
    }
}


#pragma mark ---UIScrollViewDelegate---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = _collectionView.contentOffset.x;
    
    [self adjustImgTransformWithOffsetY:offsetX];
}


//手动分页
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    float pageWidth = JRScreenWidth - 6 * JRPadding; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset - 3 * JRPadding) {
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth; //向上取整
    } else {
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth; //向下取整
    }
    
    if (newTargetOffset < 0) {
        newTargetOffset = 0;
    } else if (newTargetOffset > scrollView.contentSize.width) {
        newTargetOffset = scrollView.contentSize.width;
    }
    
    targetContentOffset->x = currentOffset;
    
    newTargetOffset = newTargetOffset - 3 * JRPadding;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
    _currentIndex = newTargetOffset / pageWidth;
}

@end
