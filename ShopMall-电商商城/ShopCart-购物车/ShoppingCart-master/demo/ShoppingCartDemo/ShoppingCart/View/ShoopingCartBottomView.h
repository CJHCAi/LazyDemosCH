//
//  ShoopingCartBottomView.h
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoopingCartBottomView;
@class ShoppingCartModel;

@protocol ShoopingCartBottomViewDelegate <NSObject>

//全选
- (void)allGoodsIsSelected:(BOOL)selccted withButton:(UIButton *)btn;

//结算
- (void)paySelectedGoods:(UIButton *)btn;

@end

@interface ShoopingCartBottomView : UIView

@property (nonatomic, weak) id <ShoopingCartBottomViewDelegate> delegate;

@property (nonatomic, strong) DDLabel *allPriceLabel;//总价

@property (nonatomic, assign) BOOL isClick;//全选按钮选中状态
@property (nonatomic, assign) BOOL payEnable;//结算安妮是否可点击

@end
