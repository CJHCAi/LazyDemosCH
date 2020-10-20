//
//  APXNumberControl.h
//  ZhongHeBao
//
//  Created by 云无心 on 17/1/3.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APXNumberControl : UIControl

/*
 * 商品数量选择控件，支持设置最小值、最大值
 * 且对输入的数值超出最大值时，仍取最后一次的有效值
 */

@property (nonatomic, assign) NSInteger minNumber; // default 1;
@property (nonatomic, assign) NSInteger maxNumber; // default 200;
@property (nonatomic, assign) NSInteger currentValue; // current value
@property (nonatomic, assign) UITextField *inputTextField; // input field
@property (nonatomic, assign) UILabel *leftTipLabel; // buy count, 数量字样

@end
