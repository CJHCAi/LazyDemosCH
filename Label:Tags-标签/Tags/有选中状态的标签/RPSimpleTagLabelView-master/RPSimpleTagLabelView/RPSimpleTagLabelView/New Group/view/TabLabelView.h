//
//  TabLabelView.h
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabLabelView;
NS_ASSUME_NONNULL_BEGIN
@protocol TabLabelViewDelegate <NSObject>

- (void)showTipMessageWithButton:(UIButton *)button;

@end

@interface TabLabelView : UIView
@property (nonatomic , strong) NSMutableArray *getArray;
@property (nonatomic, weak) id<TabLabelViewDelegate> delegate;
@property (nonatomic , assign) CGFloat heightAll;
@property (nonatomic , assign) UIColor *normalColor;
@property (nonatomic , strong) UIButton * tagBtn;
@property (nonatomic , assign) UIColor *backColor;
// 传数组 代理 背景颜色 选中颜色 正常状态下颜色
- (instancetype)initWithFrame:(CGRect)frame andTabsArray:(NSArray *)array andBackgroundColor:(UIColor *)backColor;
- (CGFloat)setCell;
@end

NS_ASSUME_NONNULL_END
