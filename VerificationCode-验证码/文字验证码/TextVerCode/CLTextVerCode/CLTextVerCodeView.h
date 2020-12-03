//
//  testView.h
//  Test
//
//  Created by zhuyuelong on 2017/4/25.
//  Copyright © 2017年 zhuyuelong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SuccessBlock)(BOOL is);

@interface CLTextVerCodeView : UIView

// 需要点击的文字数组
@property (nonatomic, strong) NSArray *resultArray;

// 文字数组
@property (nonatomic, strong) NSMutableArray *textArray;

// 文字数组
@property (nonatomic, strong) NSMutableArray *textArr;

// 每个文字的point 数组
@property (nonatomic, strong) NSMutableArray *textPoint;

// 需要点击的point 数组
@property (nonatomic, strong) NSArray *pointArr;

// 已点击的point 数组
@property (nonatomic, strong) NSMutableArray *tapArr;

// 点击顺序字符串
@property (nonatomic, strong) NSString *textString;

// 成功或失败block
@property (nonatomic, copy) SuccessBlock successBlock;

// 需要点击的文字个数
@property (nonatomic, assign) NSInteger textNum;

// 需要生成的总文字数
@property (nonatomic, assign) NSInteger textTotal;

// 背景线个数
@property (nonatomic, assign) NSInteger lineNum;

// 点击背景色
@property (nonatomic, strong) UIColor *viewColor;

// 点击背景
@property (nonatomic, strong) UIView *view;

// 刷新
- (void)change;

// 视图消失
- (void)didmiss;

@end
