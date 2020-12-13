//
//  XDRichTextModel.h
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/23.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XDRichTextModel : NSObject

@property (nonatomic ,strong)    UIImage    * kSJTextImage;

@property (nonatomic ,  copy)   NSString    * kSJTextInputText;

@property (nonatomic ,  copy)   NSString    * kSJTextSuperLinkTitle;        // 超链接标题

@property (nonatomic ,assign)   NSInteger     kSJTextChangeAttributeType;   // 状态类型(下面为状态)

@property (nonatomic ,assign)   CGFloat       kSJTextNextFont;              // 字体大小

@property (nonatomic ,assign)   BOOL          kSJTextIsOblique;             // 斜体

@property (nonatomic ,assign)   BOOL          kSJTextIsBold;                // 加粗

@property (nonatomic ,assign)   BOOL          kSJTextIsCenterLine;          // 中划线

@property (nonatomic ,assign)   BOOL          kSJTextIsUnderLine;           // 中划线

+(XDRichTextModel *)prepareDictionryChangeToModel:(NSDictionary *)dic;
@end
