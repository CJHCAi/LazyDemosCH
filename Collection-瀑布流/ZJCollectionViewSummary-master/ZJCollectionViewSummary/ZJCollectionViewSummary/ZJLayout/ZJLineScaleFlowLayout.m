//
//  ZJLineScaleFlowLayout.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/13.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJLineScaleFlowLayout.h"

#define  ITEMW  300
#define  ITENH  400

@implementation ZJLineScaleFlowLayout

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    //设置item的大小
    if (self.lineDirection == ZJWaterVertical) {
        self.itemSize = CGSizeMake(ITEMW, ITENH);
        self.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, SCREEN_WIDTH * 0.5 - ITEMW * 0.5, 0, SCREEN_WIDTH * 0.5 - ITEMW * 0.5);
        self.minimumLineSpacing = (SCREEN_WIDTH - ITEMW) * 0.25;
    }else{
        self.itemSize = CGSizeMake(ITEMW, ITENH);
        self.scrollDirection  = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(SCREEN_HEIGHT * 0.5 - ITENH * 0.5, 0, SCREEN_HEIGHT * 0.5 - ITENH * 0.5, 0);
        self.minimumLineSpacing = (SCREEN_HEIGHT - ITENH) * 0.1;
    }
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //屏幕X中间线
    CGFloat centerX = self.collectionView.contentOffset.x  + self.collectionView.bounds.size.width /2.0f;
    //屏幕Y中间线
    CGFloat centerY = self.collectionView.contentOffset.y  + self.collectionView.bounds.size.height * 0.5;
    if (self.lineDirection == ZJWaterVertical) {
        return [self calculateDistanceWithElementsInRect:rect direction:ZJWaterVertical Center:centerX dividend:self.collectionView.bounds.size.width];
    }else{
        return [self calculateDistanceWithElementsInRect:rect direction:ZJWaterHorizontal Center:centerY dividend:self.collectionView.bounds.size.height];
    }
}

- (NSArray *)copyAttributes:(NSArray  *)arr{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)calculateDistanceWithElementsInRect:(CGRect)rect direction:(ZJWaterDirection)direction Center:(CGFloat)center dividend:(CGFloat)dividend
{
    NSArray *array = [self copyAttributes: [super layoutAttributesForElementsInRect:rect]];
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attribute in array) {
        CGFloat distance = 0;
        if (direction == ZJWaterVertical) {
            distance = fabs(attribute.center.x - center);
        }else{
            distance = fabs(attribute.center.y - center);
        }
        
        //移动的距离和屏幕宽的比例
        CGFloat screenScale = distance /dividend;
        //卡片移动到固定范围内 -π/4 到 π/4
        CGFloat scale = fabs(cos(screenScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线  越居中越接近于1
        if (direction == ZJWaterVertical) {
            attribute.transform = CGAffineTransformMakeScale(1.0,scale);
        }else{
            attribute.transform = CGAffineTransformMakeScale(scale, 1.0);
        }
        //透明度
        attribute.alpha = scale;
    }
    return array;
}
@end
