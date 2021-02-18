//
//  NeedRushView.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@protocol NeedRushViewDelegate <NSObject>
/**
 *  点击cell 跳转到详情页
 */
- (void)selectCellRushGoodsId:(NSString *)goodsId;

@end

@interface NeedRushView : UIView

@property (weak,nonatomic) id<NeedRushViewDelegate>delegate;



- (void)setNeedView:(NSArray<GoodsDatalist*> *)rushArr;

@end
