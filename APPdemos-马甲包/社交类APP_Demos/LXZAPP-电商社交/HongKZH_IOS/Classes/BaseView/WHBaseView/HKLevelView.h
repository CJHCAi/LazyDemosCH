//
//  HKLevelView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKLevelView : UIView
@property(nonatomic, assign) int sex;
@property(nonatomic, assign) int level;
-(void)setSet:(int)sex level:(int)level;
@end
