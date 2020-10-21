//
//  ContainView.h
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumCell.h"
#define ALBUMCELLID @"AlbumCellIdentifier"
@interface ContainView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>)delegate;

@end
