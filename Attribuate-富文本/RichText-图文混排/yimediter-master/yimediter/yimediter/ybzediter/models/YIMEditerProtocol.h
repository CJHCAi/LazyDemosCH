//
//  YIMEditerProtocol.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#ifndef YIMEditerProtocol_h
#define YIMEditerProtocol_h
#import "HtmlElement.h"

@class YIMEditerStyle;
@class YIMEditerDrawAttributes;
@class YIMEditerTextView;

@protocol YIMEditerTextViewDelegate  <UITextViewDelegate>
-(void)textView:(YIMEditerTextView*)textView styleDidChange:(YIMEditerStyle*)style;
@end

/**文字样式变更代理*/
@protocol YIMEditerStyleChangeDelegate <NSObject>
-(void)style:(id)sender didChange:(YIMEditerStyle*)newStyle;
@end

/**
 比较重要的一个接口
 表示一个可以改变文本样式的的对象接口
 实现该接口可以更改文本属性
 */
@protocol YIMEditerStyleChangeObject <NSObject>

/**样式修改的代理，在样式需要修改时，对象需要调用代理的didChange方法*/
@property(nonatomic,weak)id<YIMEditerStyleChangeDelegate> styleDelegate;
/**提供一个默认样式*/
@property(nonatomic,strong,readonly)YIMEditerStyle *defualtStyle;
/** 对象当前的样式 */
@property(nonatomic,strong,readonly)YIMEditerStyle *currentStyle;
/**根据文字属性返回一个该Object的style*/
-(YIMEditerStyle*)styleUseAttributed:(YIMEditerDrawAttributes*)attributed;
/**根据html标签返回文字属性*/
-(YIMEditerDrawAttributes*)attributesUseHtmlElement:(struct HtmlElement)element isParagraphElement:(BOOL)isParagraph content:(NSString**)content;
/** 使用Attributes更新样式，需要在此处更新UI以适应新的样式**/
-(void)updateUIWithTextAttributes:(YIMEditerDrawAttributes*)attributed;

@end


#endif /* YIMEditerProtocol_h */
