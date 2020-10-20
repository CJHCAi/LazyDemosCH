//
//  CollectionViewLayout.h
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/16.
//  Copyright © 2017年 lujh. All rights reserved.
//

@protocol CollectionViewLayoutDelegate <NSObject>

@optional;

-(CGFloat)heightOfSectionHeaderForIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)heightOfSectionFooterForIndexPath:(NSIndexPath *)indexPath;

@end

@interface CollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<CollectionViewLayoutDelegate>delegate;

@end
