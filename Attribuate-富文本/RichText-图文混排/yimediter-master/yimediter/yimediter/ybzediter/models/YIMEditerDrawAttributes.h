//
//  YIMEditerDrawAttributes.h
//  yimediter
//
//  Created by ybz on 2017/12/1.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIMEditerStyle.h"

@class YIMEditerTextView;

/**
 表示文字绘制属性  之所以用一个类而不直接用NSDictionary，是防止出现无法使用NSAttributedString实现的时候，在此处添加其余的属性
 */
@interface YIMEditerDrawAttributes : NSObject

-(instancetype)initWithAttributeString:(NSDictionary*)attribute;

/**文字样式*/
@property(nonatomic,copy,readonly)NSDictionary* textAttributed;
/**
 段落样式
 文字样式中包含该样式
 段落样式会应用到一段文字
 */
@property(nonatomic,copy,readonly)NSDictionary* paragraphAttributed;

/**
 刷新属性
 */
-(void)updateAttributed:(YIMEditerDrawAttributes*)attributed;

@end



@interface YIMEditerMutableDrawAttributes : YIMEditerDrawAttributes
@property(nonatomic,copy)NSDictionary *textAttributed;
@property(nonatomic,copy)NSDictionary* paragraphAttributed;
@end
