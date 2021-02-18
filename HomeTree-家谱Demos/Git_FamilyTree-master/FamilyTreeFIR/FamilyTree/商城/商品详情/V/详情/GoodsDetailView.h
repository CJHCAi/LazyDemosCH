//
//  GoodsDetailView.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodPayModel.h"
#import "GoodDetailModel.h"
#import "StarView.h"
@protocol GoodsDetailViewDelegate <NSObject>

- (void)allCommentShow;

@end

@interface GoodsDetailView : UIView
/**
 *  高度
 */
@property (nonatomic) CGFloat detailH;

/**
 *  选中商品
 */
@property (strong,nonatomic) GoodPayModel *chooseGood;

@property (strong,nonatomic) UILabel *commentNumberLb;
@property (strong,nonatomic) StarView *starV;

- (void)getGoodData:(GoodDetailModel *)sender;

@property (weak,nonatomic) id<GoodsDetailViewDelegate>delegate;
@end
