//
//  ASCollectionViewFlowLayoutInspector.h
//  AsyncDisplayKit
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//

#pragma once

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASDimension.h>

@class ASCollectionView;
@protocol ASCollectionDelegate;

@protocol ASCollectionViewLayoutInspecting <NSObject>

/**
 * Provides the size range needed to measure the collection view's item.
 */
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Asks the inspector to provide a constrained size range for the given supplementary node.
 */
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

/**
 * Asks the inspector for the number of supplementary sections in the collection view for the given kind.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView numberOfSectionsForSupplementaryNodeOfKind:(NSString *)kind;

/**
 * Asks the inspector for the number of supplementary views for the given kind in the specified section.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section;

@optional

/**
 * Allow the inspector to respond to delegate changes.
 *
 * @discussion A great time to update perform selector caches!
 */
- (void)didChangeCollectionViewDelegate:(id<ASCollectionDelegate>)delegate;

@end

@interface ASCollectionViewFlowLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>

@property (nonatomic, weak) UICollectionViewFlowLayout *layout;

- (instancetype)initWithCollectionView:(ASCollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout;

@end
