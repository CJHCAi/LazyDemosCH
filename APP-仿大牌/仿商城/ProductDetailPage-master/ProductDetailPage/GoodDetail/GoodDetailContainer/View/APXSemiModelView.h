//
//  APXSemiModelView.h
//  ZhongHeBao
//
//  Created by yangyang on 2016/12/23.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface APXSemiModelView : UIView

// 弹出类,商品详情处弹出效果
- (instancetype)initWithContentView:(UIView *)contentView viewController:(UIViewController *)viewController;

- (void)show;

- (void)dismiss;

@end
