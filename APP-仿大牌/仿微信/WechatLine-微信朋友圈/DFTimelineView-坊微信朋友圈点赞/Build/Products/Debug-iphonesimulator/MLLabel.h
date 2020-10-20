//
//  MLLabel.h
//  MLLabel
//
//  Created by molon on 15/5/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLLastTextType) {
    MLLastTextTypeNormal,
    MLLastTextTypeAttributed,
};
// UILabel的baselineAdjustment属性功能没模拟,其他的属性都模拟了

@interface MLLabel : UILabel

@property (nonatomic, assign) CGFloat lineHeightMultiple; //行高的multiple
@property (nonatomic, assign) CGFloat lineSpacing; //行间距

@property (nonatomic, assign) UIEdgeInsets textInsets;

@property (nonatomic, copy) void(^doBeforeDrawingTextBlock)(CGRect rect,CGPoint beginOffset,CGSize drawSize);

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;


//方便码代码
- (void)setDoBeforeDrawingTextBlock:(void (^)(CGRect rect,CGPoint beginOffset,CGSize drawSize))doBeforeDrawingTextBlock;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com