//
//  NSMutableAttributedString+MLLabel.h
//  MLLabel
//
//  Created by molon on 15/6/5.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MLLabel)

- (void)removeAllNSOriginalFontAttributes;

- (void)removeAttributes:(NSArray *)names range:(NSRange)range;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com