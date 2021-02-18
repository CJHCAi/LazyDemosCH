//
//  GuessLikeView.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@protocol  GuessLikeViewDelegate<NSObject>

- (void)selectCellLikeGoodsid:(NSString *)goodsId;

@end

@interface GuessLikeView : UIView

@property (weak,nonatomic) id<GuessLikeViewDelegate>delegate;

- (void)setLikeView:(NSArray<GoodsDatalist*> *)LikeArr;

@end
