//
//  CemGoodsShopView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CemGoodsShopModel.h"

@class CemGoodsShopView;

@protocol CemGoodsShopViewDelegate <NSObject>

-(void)uploadGoodsToRefreshcemGoods:(NSArray<CemGoodsShopModel *> *)goodsArr;

@end

@interface CemGoodsShopView : UIView

/** 所有贡品视图*/
@property (nonatomic, strong) UIView *singleGoods;

/** 墓园ID*/
@property (nonatomic, assign) NSInteger CeId;

/** 代理人*/
@property (nonatomic, weak) id<CemGoodsShopViewDelegate> delegate;
@end
