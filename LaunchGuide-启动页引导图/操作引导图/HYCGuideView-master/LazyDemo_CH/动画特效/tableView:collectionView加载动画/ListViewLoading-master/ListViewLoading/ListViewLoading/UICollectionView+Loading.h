//
//  UICollectionView+Loading.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UICollectionViewLoadingDelegate <NSObject>
@required
- (NSInteger)loadingCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)loadingCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)sectionsOfloadingCollectionView:(UICollectionView *)collectionView;
- (UICollectionReusableView *)loadingCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionView (Loading)
@property (nonatomic, readonly)BOOL loading;
@property (nonatomic, weak)id<UICollectionViewLoadingDelegate> loadingDelegate;

- (void)startLoading;
- (void)stopLoading;

@end
NS_ASSUME_NONNULL_END
