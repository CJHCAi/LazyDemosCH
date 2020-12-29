//
//  RecruitAccountChoiceView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
//账户类型 View : 求职者 企业
@interface RecruitAccountChoiceView : UIControl

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text color:(UIColor *)color;

+ (instancetype)viewWithImage:(UIImage *)image text:(NSString *)text color:(UIColor *)color;

@end
