//
//  ShopActionView.h
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopActionViewDelegate <NSObject>
/**
 *  订单操作
 */
- (void)shopAction:(UIButton *)sender;

@end

@interface ShopActionView : UIView

/**
 *  根据订单类型获取订单的可执行操作
 *
 */
- (void)initWith:(NSInteger)type;

@property (weak,nonatomic) id<ShopActionViewDelegate>delegate;
@end
