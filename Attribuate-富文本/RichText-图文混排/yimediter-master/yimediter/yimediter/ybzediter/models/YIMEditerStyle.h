//
//  YIMEditerStyle.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HtmlElement.h"

@class YIMEditerDrawAttributes;

/**表示样式基类*/
@interface YIMEditerStyle : NSObject <NSCopying>

/**是否段落样式*/
@property(nonatomic,assign,readonly)BOOL isParagraphStyle;

/**创建默认样式*/
+(instancetype)createDefualtStyle;

/**根据文字绘制属性初始化*/
-(instancetype)initWithAttributed:(YIMEditerDrawAttributes*)attributed;

/**输出绘制属性*/
-(YIMEditerDrawAttributes*)outPutAttributed;

/**html的style*/
-(NSString*)htmlStyle;
/**html需要包含的标签*/
-(NSArray<NSString*>*)htmlAttributed;

+(instancetype)createWithHtmlElement:(struct HtmlElement)element content:(NSString**)content;

@end
