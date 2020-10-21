//
//  SJVideoPlayerURLAsset.h
//  SJVideoPlayerProject
//
//  Created by 畅三江 on 2018/1/29.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPlayModel.h"
#import "SJMediaPlaybackProtocol.h"

@protocol SJVideoPlayerURLAssetObserver;
@class AVAsset;

NS_ASSUME_NONNULL_BEGIN

@interface SJVideoPlayerURLAsset : NSObject<SJMediaModelProtocol>
- (id<SJVideoPlayerURLAssetObserver>)getObserver;
- (instancetype)initWithURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime playModel:(__kindof SJPlayModel *)playModel;
- (instancetype)initWithURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime;
- (instancetype)initWithURL:(NSURL *)URL playModel:(__kindof SJPlayModel *)playModel;
- (instancetype)initWithURL:(NSURL *)URL;
@property (nonatomic, strong, null_resettable) SJPlayModel *playModel;
@property (nonatomic, readonly) BOOL isM3u8; 

- (instancetype)initWithOtherAsset:(SJVideoPlayerURLAsset *)otherMedia playModel:(nullable __kindof SJPlayModel *)playModel;
@property (nonatomic, weak, readonly, nullable) SJVideoPlayerURLAsset *otherMedia;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end


@protocol SJVideoPlayerURLAssetObserver <NSObject>
@property (nonatomic, copy, nullable) void(^playModelDidChangeExeBlock)(SJVideoPlayerURLAsset *asset);
@end


/// 已弃用
@interface SJVideoPlayerURLAsset (Deprecated)
- (instancetype)initWithAssetURL:(NSURL *)assetURL __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL beginTime:(NSTimeInterval)beginTime __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL scrollView:(__unsafe_unretained UIScrollView * __nullable)tableOrCollectionView indexPath:(NSIndexPath * __nullable)indexPath superviewTag:(NSInteger)superviewTag __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL beginTime:(NSTimeInterval)beginTime scrollView:(__unsafe_unretained UIScrollView *__nullable)tableOrCollectionView indexPath:(NSIndexPath *__nullable)indexPath superviewTag:(NSInteger)superviewTag __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL beginTime:(NSTimeInterval)beginTime playerSuperViewOfTableHeader:(__weak UIView *)superView tableView:(UITableView *)tableView __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL beginTime:(NSTimeInterval)beginTime collectionViewOfTableHeader:(__weak UICollectionView *)collectionView collectionCellIndexPath:(NSIndexPath *)indexPath playerSuperViewTag:(NSInteger)playerSuperViewTag rootTableView:(UITableView *)rootTableView __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
- (instancetype)initWithAssetURL:(NSURL *)assetURL beginTime:(NSTimeInterval)beginTime indexPath:(NSIndexPath *__nullable)indexPath superviewTag:(NSInteger)superviewTag scrollViewIndexPath:(NSIndexPath *__nullable)scrollViewIndexPath scrollViewTag:(NSInteger)scrollViewTag rootScrollView:(__unsafe_unretained UIScrollView *__nullable)rootScrollView __deprecated_msg("已弃用, 请使用 `initWithURL:playModel:`;");
+ (instancetype)assetWithOtherAsset:(SJVideoPlayerURLAsset *)asset __deprecated_msg("已弃用, 请使用 `initWithOtherAsset:playModel`;");
+ (instancetype)assetWithOtherAsset:(SJVideoPlayerURLAsset *)asset scrollView:(__unsafe_unretained UIScrollView * __nullable)tableOrCollectionView indexPath:(NSIndexPath * __nullable)indexPath superviewTag:(NSInteger)superviewTag __deprecated_msg("已弃用, 请使用 `initWithOtherAsset:playModel`;");
+ (instancetype)assetWithOtherAsset:(SJVideoPlayerURLAsset *)asset playerSuperViewOfTableHeader:(__unsafe_unretained UIView *)superView tableView:(__unsafe_unretained UITableView *)tableView __deprecated_msg("已弃用, 请使用 `initWithOtherAsset:playModel`;");
+ (instancetype)assetWithOtherAsset:(SJVideoPlayerURLAsset *)asset collectionViewOfTableHeader:(__unsafe_unretained UICollectionView *)collectionView collectionCellIndexPath:(NSIndexPath *)indexPath playerSuperViewTag:(NSInteger)playerSuperViewTag rootTableView:(__unsafe_unretained UITableView *)rootTableView __deprecated_msg("已弃用, 请使用 `initWithOtherAsset:playModel`;");
+ (instancetype)assetWithOtherAsset:(SJVideoPlayerURLAsset *)asset indexPath:(NSIndexPath *__nullable)indexPath superviewTag:(NSInteger)superviewTag scrollViewIndexPath:(NSIndexPath *__nullable)scrollViewIndexPath scrollViewTag:(NSInteger)scrollViewTag rootScrollView:(__unsafe_unretained UIScrollView *__nullable)rootScrollView __deprecated_msg("已弃用, 请使用 `initWithOtherAsset:playModel`;");
@end
NS_ASSUME_NONNULL_END
