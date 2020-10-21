//
//  CXSearchLayout.m
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXSearchLayout.h"


@implementation CXSearchLayout

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

//定义屏幕展示的范围和数量
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 获取系统计算好的Attributes
    NSArray * attributesToReturn = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];//copyItems将系统的Attributes进行拷贝
    /*
     也可以这样写
     NSArray* arrayattributesToReturn = [super layoutAttributesForElementsInRect:rect];
     NSArray * attributesToReturn = [[NSArray alloc] initWithArray:arrayattributesToReturn copyItems:YES];
     */
    // 遍历
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        /*
         typedef NS_ENUM(NSUInteger, UICollectionElementCategory) {
         UICollectionElementCategoryCell,
         UICollectionElementCategorySupplementaryView,
         UICollectionElementCategoryDecorationView
         };
         */
        // representedElementKind == nil 时 representedElementCategory 为 UICollectionElementCategoryCell 即此时的attributes为item
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            //对每个attributes的frame重新布局
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

//定义cell的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取系统计算好的当前的Attributes
    UICollectionViewLayoutAttributes * currentItemAttributes =
    [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    //设置内边距
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    
    //如果是第一个item。则其frame.origin.x直接在内边距的左边。重置currentItemAttributes的frame 返回currentItemAttributes
    
    if (indexPath.item == 0) { // first item of section
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
        currentItemAttributes.frame = frame;
        //返回currentItemAttributes
        return currentItemAttributes;
    }
    
    //如果不是第一个item。则需要获取前一个item的Attributes的frame属性
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    
    //前一个item与当前的item的相邻点
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + self.listItemSpace;
    //当前的frame
    CGRect currentFrame = currentItemAttributes.frame;
    //
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentFrame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    //判断两个结构体是否有交错.可以用CGRectIntersectsRect
    //如果两个结构体没有交错，则表明这个item与前一个item不在同一行上。则其frame.origin.x直接在内边距的左边。重置currentItemAttributes的frame 返回currentItemAttributes
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) {
        // if current item is the first item on the line
        // the approach here is to take the current frame, left align it to the edge of the view
        // then stretch it the width of the collection view, if it intersects with the previous frame then that means it
        // is on the same line, otherwise it is on it's own new line
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item on the line should always be left aligned
        currentItemAttributes.frame = frame;
        //返回currentItemAttributes
        return currentItemAttributes;
    }
    //如果如果两个结构体有交错。将前一个item与当前的item的相邻点previousFrameRightPoint赋值给当前的item的frame.origin.x
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint;
    currentItemAttributes.frame = frame;
    //返回currentItemAttributes
    return currentItemAttributes;
}

@end
