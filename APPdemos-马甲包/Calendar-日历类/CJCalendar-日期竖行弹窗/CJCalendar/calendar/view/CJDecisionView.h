//
//  CJDecisionView.h
//  CJCalendar
//
//  Created by chjsun on 16/5/25.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJDecisionView;
@protocol DecisionDelegate <NSObject>

@optional
-(void) DecisionDidSelectNow: (CJDecisionView *)decision;

-(void) DecisionDidSelectCancel: (CJDecisionView *)decision;

-(void) DecisionDidSelectAction: (CJDecisionView *)decision;

@end

@interface CJDecisionView : UIView

//初始化
-(void) generateDecision;

/** 代理 */
@property (nonatomic, assign) id<DecisionDelegate> delegate;

/** 按钮文字颜色 */
@property (nonatomic, copy) UIColor *textColor;
/** 点击按钮文字颜色 */
@property (nonatomic, copy) UIColor *selectColor;
@end
