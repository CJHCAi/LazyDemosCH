//
//  MLLabel+Override.h
//  MLLabel
//
//  Created by molon on 15/6/6.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabel.h"

@class MLLabelLayoutManager;
@interface MLLabel (Override)

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) MLLabelLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSAttributedString *lastAttributedText;
@property (nonatomic, assign) MLLastTextType lastTextType;

//初始化
- (void)commonInit;

//复写这个可以最终文本改变
- (NSMutableAttributedString*)attributedTextForTextStorageFromLabelProperties;

//获取绘制起点
- (CGPoint)textOffsetWithTextSize:(CGSize)textSize;

//可以完全重绘当前label
- (void)reSetText;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com