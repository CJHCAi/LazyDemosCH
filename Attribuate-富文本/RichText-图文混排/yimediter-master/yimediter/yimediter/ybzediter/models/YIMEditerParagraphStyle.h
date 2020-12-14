//
//  YIMEditerParagraphStyle.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyle.h"
#import <UIKit/UIKit.h>

/**
 段落样式
 */
@interface YIMEditerParagraphStyle : YIMEditerStyle

/**段落首行是否锁进*/
@property (nonatomic,assign) BOOL firstLineIndent;
/**段落的对齐方式*/
@property (nonatomic,assign)NSTextAlignment alignment;
/**行间距*/
@property (nonatomic,assign)CGFloat lineSpacing;


+(instancetype)createDefualtStyle;

@end
