//
//  CemSingleGoodsCollectionViewCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CemGoodsShopModel.h"

@interface CemSingleGoodsCollectionViewCell : UICollectionViewCell
/** 贡品模型*/
@property (nonatomic, strong) CemGoodsShopModel *cemGoodsShopModel;
/** 是否选中图片*/
@property (nonatomic,assign) BOOL selectedItem;

@end
