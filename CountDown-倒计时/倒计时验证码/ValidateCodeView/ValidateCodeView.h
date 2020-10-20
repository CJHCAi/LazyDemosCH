//
//  validateCodeView.h
//  ValidateCodeView
//
//  Created by zhuming on 16/3/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValidateCodeDelegate <NSObject>

@optional
/**
 *  点击后开始倒计时
 */
- (void)startTimeCount;
/**
 *  倒计时结束
 */
- (void)endTimeCount;

@end

@interface ValidateCodeView : UIView

/**
 *  代理
 */
@property (nonatomic,weak)id<ValidateCodeDelegate>delegate;

/**
 *  初始化视图
 *
 *  @param frame      frame
 *  @param timerCount 倒计时长度
 *
 *  @return 视图
 */
- (instancetype)initWithFrame:(CGRect)frame timerCount:(NSInteger)timerCount;

/**
 *  获取验证码按钮是否可以点击
 *
 *  @param isCan YES: 可以点击   NO:不可以点击
 */
- (void)canGetYzm:(BOOL)isCan;

/**
 *  还原验证码控件
 *  控制器消失的时候 需要调用这个方法
 */
-(void)reset;

@end
