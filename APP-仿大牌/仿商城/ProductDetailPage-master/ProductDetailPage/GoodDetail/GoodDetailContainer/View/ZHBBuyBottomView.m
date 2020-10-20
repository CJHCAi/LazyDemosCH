//
//  ZHBBuyBottomView.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/15.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBBuyBottomView.h"
//#import "UIButton+ImageTitleAlignment.h"

@implementation ZHBBuyBottomView


- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置badge
//    self.goToShopcarBtn.badgeView.position = CGPointMake(0.7, 0.25);
//    self.goToShopcarBtn.badgeView.animation = AXBadgeViewAnimationNone;
//    self.goToShopcarBtn.badgeView.style = AXBadgeViewText;
//    [self.goToShopcarBtn showBadge:YES];
}

#pragma mark - public
+ (instancetype)buyBottomView
{
    ZHBBuyBottomView *buyBottom = [[[NSBundle mainBundle] loadNibNamed:@"ZHBBuyBottomView" owner:nil options:nil] firstObject];
    return buyBottom;
}

- (void)bottomInteractionDisable
{
    self.addShopcarBtn.userInteractionEnabled = NO;
    self.buyBtn.userInteractionEnabled = NO;
    [self.addShopcarBtn setBackgroundColor:ColorWithHex(0XF9FAFB)];
    [self.addShopcarBtn setTitleColor:ColorWithHex(0XE2E1E1) forState:UIControlStateNormal];
    [self.buyBtn setBackgroundColor:ColorWithHex(0XE2E1E1)];
    [self.buyBtn setTitleColor:ColorWithHex(0xFFFFFF) forState:UIControlStateNormal];
}


#pragma mark - clickResponse
- (IBAction)attentionBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyBottomView:didClickBuyBottomClickType:)]) {
        [self.delegate buyBottomView:self didClickBuyBottomClickType:BuyBottomClickTypeAttention];
    }
}
- (IBAction)goToShopCarBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyBottomView:didClickBuyBottomClickType:)]) {
        [self.delegate buyBottomView:self didClickBuyBottomClickType:BuyBottomClickTypeGoToShopcar];
    }
}
- (IBAction)addShopCarBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyBottomView:didClickBuyBottomClickType:)]) {
        [self.delegate buyBottomView:self didClickBuyBottomClickType:BuyBottomClickTypeAddShopcar];
    }

}
- (IBAction)buyBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyBottomView:didClickBuyBottomClickType:)]) {
        [self.delegate buyBottomView:self didClickBuyBottomClickType:BuyBottomClickTypeBuy];
    }

}


@end
