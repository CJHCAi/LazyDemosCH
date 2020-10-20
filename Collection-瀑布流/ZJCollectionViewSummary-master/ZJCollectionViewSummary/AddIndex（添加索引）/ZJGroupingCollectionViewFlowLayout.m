//
//  ZJGroupingCollectionViewFlowLayout.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJGroupingCollectionViewFlowLayout.h"

@implementation ZJGroupingCollectionViewFlowLayout

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat cellSpace = 3.0;
    CGFloat cellWidth = (SCREEN_WIDTH - 20) / 3.0;
    
    self.itemSize = CGSizeMake(cellWidth, cellWidth  * 0.8);
    self.minimumInteritemSpacing = cellSpace;
    self.minimumLineSpacing = cellSpace;
    //    self.sectionHeadersPinToVisibleBounds = YES;//header 悬浮
    self.sectionInset = UIEdgeInsetsMake(cellSpace, cellSpace, cellSpace, cellSpace);
    self.headerReferenceSize = CGSizeMake(size.width, 40);
    
    return self;
}
@end
