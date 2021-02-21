//
//  YCBaseCollectionController.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseViewController.h"

@interface YCBaseCollectionController : YCBaseViewController

@property (nonatomic, assign) NSInteger        pageNum;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@property (nonatomic, strong) NSIndexPath      *indexPath;
@property (nonatomic, strong) UIView           *noResultView;
@property (nonatomic, strong) UIImageView      *noResultImaV;
@property (nonatomic, assign) CGFloat          lastOffSetY;
@property (nonatomic, assign) CGFloat          lastOffSetX;

@property (nonatomic, assign) BOOL             loading;
@property (nonatomic, assign) BOOL             bFirstLoad;
@property (nonatomic, assign) BOOL             scrollBottom;
@property (nonatomic, assign) BOOL             bEdit;

- (void)setUpLayOut;
- (void)setUpCollectionView;
- (void)registerCell;

- (void)addRefreshHeader;
- (void)addLoadMoreFooter;

- (void)loadNewData;
- (void)loadMoreData;
- (void)requestData;
- (void)endRefresh;

- (void)addNoResultView;
- (void)removeNoResultView;

- (void)tapAction;

@end
