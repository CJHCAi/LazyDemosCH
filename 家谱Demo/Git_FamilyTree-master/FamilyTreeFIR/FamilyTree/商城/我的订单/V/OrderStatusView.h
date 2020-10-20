//
//  OrderStatusView.h
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderStatusViewDelegate <NSObject>

-(void)orderTypeChoose:(UIButton *)sender;

@end

@interface OrderStatusView : UIView
/**
 * 根据状态栏数量初始化界面
 */
- (void)initTypeArr:(NSArray *)arr;

@property (weak,nonatomic) id<OrderStatusViewDelegate>delegate;

@end
