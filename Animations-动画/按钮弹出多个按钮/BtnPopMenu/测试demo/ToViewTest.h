//
//  ToViewTest.h
//  HighWay
//
//  Created by SunLi on 16/7/2.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToViewTest : UIView

@property(nonatomic, strong)NSString *currValue;
@property(nonatomic, strong)NSString *totalValue;
//是否处于滚动状态
@property(nonatomic, assign)BOOL isRolling;
@end
