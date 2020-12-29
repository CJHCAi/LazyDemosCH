//
//  UITableView+CellHeightCache.h
//
//  Created by lightman on 16/3/14.
//  Copyright © 2016年 YCTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHeightCache : NSObject

@property(nonatomic,assign) CGFloat cellHeight;

- (BOOL)existsHeightForKey:(id<NSCopying>)key;
- (void)cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key;
- (CGFloat)heightForKey:(id<NSCopying>)key;

@end

@interface UITableView (CellHeightCache)

@property(nonatomic,strong,readonly) CellHeightCache *cellHeightCache;

- (CGFloat)getCellHeightCacheWithCacheKey:(NSString *)cacheKey;

- (void)setCellHeightCacheWithCellHeight:(CGFloat)cellHeight CacheKey:(NSString *)cacheKey;

@end
