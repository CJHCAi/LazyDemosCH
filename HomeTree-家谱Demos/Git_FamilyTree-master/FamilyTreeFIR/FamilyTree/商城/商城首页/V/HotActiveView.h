//
//  HotActiveView.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol HotActiveViewDelegate <NSObject>
/**
 *  点击cell 跳转到详情页面
 */
- (void)selectCellGoodsId:(NSString *)goodsId;

@end

@interface HotActiveView : UIView

@property (weak,nonatomic) id<HotActiveViewDelegate>delegate;

@property (strong,nonatomic) UICollectionView *collectionV;

@property (strong,nonatomic) NSArray<GoodsDatalist *> *hotArr;

- (void)setinitValue:(NSArray<GoodsDatalist *>*)hotArr;


@end
