//
//  ZHBBuyBottomView.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/15.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BuyBottomClickType) {
    BuyBottomClickTypeAttention,
    BuyBottomClickTypeGoToShopcar,
    BuyBottomClickTypeAddShopcar,
    BuyBottomClickTypeBuy,
};


@class ZHBBuyBottomView;
@protocol ZHBBuyBottomViewDeleagte <NSObject>

- (void)buyBottomView:(ZHBBuyBottomView *)buyBottomView didClickBuyBottomClickType:(BuyBottomClickType)buyBottomClickType;

@end


@interface ZHBBuyBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn; //关注
@property (weak, nonatomic) IBOutlet UIButton *goToShopcarBtn; // 购物车
@property (weak, nonatomic) IBOutlet UIButton *addShopcarBtn; // 加入购物车
@property (weak, nonatomic) IBOutlet UIButton *buyBtn; // 立即购买

@property (assign, nonatomic) id delegate;


+ (instancetype)buyBottomView;

// 无货等情况让下方按钮失效
- (void)bottomInteractionDisable;

@end
