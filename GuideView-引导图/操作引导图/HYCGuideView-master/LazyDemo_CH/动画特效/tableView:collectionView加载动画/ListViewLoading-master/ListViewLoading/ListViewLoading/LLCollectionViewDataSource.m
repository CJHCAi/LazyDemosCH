//
//  LLCollectionViewDataSource.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/16.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "LLCollectionViewDataSource.h"
#import "UIView+Sunshine.h"

@interface LLCollectionViewDataSource ()<UICollectionViewDataSource>

@end

@implementation LLCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView loading]) {
        return [self.loadingDelegate loadingCollectionView:collectionView numberOfItemsInSection:section];
    }else {
        return [self.replace_dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView loading]) {
        UICollectionViewCell *cell = [self.loadingDelegate loadingCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        [self beginLoadingAnimation:cell];
        return cell;
    }else {
        UICollectionViewCell *cell = [self.replace_dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
        [self stopLoadingAnimation:cell];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([collectionView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(sectionsOfloadingCollectionView:)]) {
            return [self.loadingDelegate sectionsOfloadingCollectionView:collectionView];
        }
        return 1;
    }else {
        if ([self.replace_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            return [self.replace_dataSource numberOfSectionsInCollectionView:collectionView];
        }
        return 1;
    }
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView loading]) {
        if ([self.loadingDelegate respondsToSelector:@selector(loadingCollectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionReusableView *header = [self.loadingDelegate loadingCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
            [self beginLoadingAnimation:header];
            return header;
        }
        return nil;
    }else {
        if ([self.replace_dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionReusableView *header = [self.replace_dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
            [self stopLoadingAnimation:header];
            return header;
        }
        return nil;
    }
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 && TARGET_OS_IOS
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        return [self.replace_dataSource collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    if ([self.replace_dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.replace_dataSource collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 102000 && TARGET_OS_IOS
/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView{
    if ([self.replace_dataSource respondsToSelector:@selector(indexTitlesForCollectionView:)]) {
        return [self.replace_dataSource indexTitlesForCollectionView:collectionView];
    }
    return nil;
}

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.replace_dataSource respondsToSelector:@selector(collectionView:indexPathForIndexTitle:atIndex:)]) {
        return [self.replace_dataSource collectionView:collectionView indexPathForIndexTitle:title atIndex:index];
    }
    return nil;
}
#endif

- (void)beginLoadingAnimation:(__kindof UIView *)view {
    [view beginSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self beginLoadingAnimation:subview];
    }
}

- (void)stopLoadingAnimation:(__kindof UIView *)view {
    [view endSunshineAnimation];
    for (UIView *subview in view.subviews) {
        [self stopLoadingAnimation:subview];
    }
}
@end
