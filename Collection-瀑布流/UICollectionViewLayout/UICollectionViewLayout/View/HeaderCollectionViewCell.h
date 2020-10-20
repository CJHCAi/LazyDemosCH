//
//  HeaderCollectionViewCell.h
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/22.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
// UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
// UIPageControl
@property (nonatomic, strong) UIPageControl *pageControl;
// UICollectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@end
