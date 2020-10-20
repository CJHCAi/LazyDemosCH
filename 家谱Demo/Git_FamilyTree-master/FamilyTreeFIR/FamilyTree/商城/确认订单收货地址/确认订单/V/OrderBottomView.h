//
//  OrderBottomView.h
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderBottomView;
@protocol OrderBottomViewDelegate <NSObject>
@optional
-(void)OrderBottonView:(OrderBottomView *)orderView didTapClearButton:(UIButton *)sender;


@end
@interface OrderBottomView : UIView
/**
 *  订单报价
 */
@property (strong,nonatomic) UILabel *orderQuoteLb;
/**
 *  运费
 */
@property (strong,nonatomic) UILabel *orderFreightLb;
/**
 *  优惠
 */
@property (strong,nonatomic) UILabel *concessionsLb;
/**
 *  应付金额
 */
@property (strong,nonatomic) UILabel *orderPayLb;
@property (nonatomic,weak) id<OrderBottomViewDelegate> delegate; /*代理人*/

@end
