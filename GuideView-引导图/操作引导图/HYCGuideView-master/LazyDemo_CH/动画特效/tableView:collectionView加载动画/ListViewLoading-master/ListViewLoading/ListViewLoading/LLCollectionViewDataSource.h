//
//  LLCollectionViewDataSource.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/16.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICollectionView+Loading.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLCollectionViewDataSource : NSObject
@property (nonatomic, weak)id<UICollectionViewDataSource> replace_dataSource;
@property (nonatomic, weak)id<UICollectionViewLoadingDelegate> loadingDelegate;
@end

NS_ASSUME_NONNULL_END
