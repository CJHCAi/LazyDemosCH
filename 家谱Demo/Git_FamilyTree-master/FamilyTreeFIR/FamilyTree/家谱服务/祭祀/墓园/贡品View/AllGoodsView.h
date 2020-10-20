//
//  AllGoodsView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllGoodsView : UIView
/** 祭祀贡品数组*/
@property (nonatomic, strong) NSArray *goodsArr;

/** 被选定的商品数组*/
@property (nonatomic, strong) NSMutableArray *isSelectedGoodsArr;
@end
