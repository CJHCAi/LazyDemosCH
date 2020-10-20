//
//  UIView+Category.h
//  MMSideslipDrawer
//
//  Created by LEA on 2017/2/17.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

/**右下角 左下角 右上角  左上角（起始点）*/
@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;
@property CGPoint origin;

/**宽 高 尺寸*/
@property CGFloat height;
@property CGFloat width;
@property CGSize size;

/**中心点 X Y*/
@property CGFloat centetX;
@property CGFloat centetY;


/**上 左 下 右 */
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;
/**最小值，最大值（等同: 上 左 下 右）*/
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;


@end
