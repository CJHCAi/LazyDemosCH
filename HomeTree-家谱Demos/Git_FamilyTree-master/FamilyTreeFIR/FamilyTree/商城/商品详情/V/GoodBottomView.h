//
//  GoodBottomView.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodBottomViewDelegate <NSObject>
/**
 *  选择加入购物车或者购买
 */
- (void)payOrShop:(UIButton *)sender;

@end

@interface GoodBottomView : UIView

@property (weak,nonatomic) id<GoodBottomViewDelegate>delegate;

@end
