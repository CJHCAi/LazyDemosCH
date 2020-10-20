

//
//  HederCollectionViewLayout.m
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/24.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "HederCollectionViewLayout.h"


@interface HederCollectionViewLayout ()

@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, strong) NSMutableArray *attrsArr;
@end

@implementation HederCollectionViewLayout

-(void)prepareLayout {
    
    [super prepareLayout];
    self.totalHeight = 0;
    NSMutableArray *attributesArr = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {

        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < itemCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [attributesArr addObject:attrs];
        }

    }
    self.attrsArr = [NSMutableArray arrayWithArray:attributesArr];
}

/// contentSize
-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.totalHeight);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
   [self layoutAttributesForCopyRightlayout:layoutAttributes indexPath:indexPath];

    return layoutAttributes;
}

// 版权
- (void)layoutAttributesForCopyRightlayout:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath: (NSIndexPath *) indexPath {
    
    CGFloat y = self.totalHeight;
    CGFloat W = 80;
    CGFloat H = W;
    CGFloat leftAndRightPading = (SCREEN_WIDTH - 3*W)/4.0;
    CGFloat topAndBottomPading = (200 - 2*80)/3.0;
    
    
    long row = (indexPath.item ) % 6;
    
    if (indexPath.item == 3 || indexPath.item == 4 ||indexPath.item ==5 || indexPath.item == 9||indexPath.item == 10||indexPath.item == 11) {
        
        layoutAttributes.frame = CGRectMake(row * (W +leftAndRightPading) +leftAndRightPading*2, y +topAndBottomPading, W, H);
    }else {
    
        layoutAttributes.frame = CGRectMake(row * (W +leftAndRightPading) +leftAndRightPading, y +topAndBottomPading, W, H);
    }
    
    if (indexPath.item == 5 || indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        self.totalHeight += (H +topAndBottomPading);
    }
}

@end
