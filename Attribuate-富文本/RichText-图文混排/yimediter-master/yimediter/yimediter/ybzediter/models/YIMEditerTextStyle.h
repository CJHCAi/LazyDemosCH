//
//  YIMEditerTextStyle.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyle.h"
#import <UIKit/UIKit.h>
#import "HtmlElement.h"


/**
 文字样式
 */
@interface YIMEditerTextStyle : YIMEditerStyle <NSCopying>

/**是否粗体*/
@property(nonatomic,assign)BOOL bold;
/**是否斜体*/
@property (nonatomic, assign) BOOL italic;
/**是否带下划线*/
@property (nonatomic, assign) BOOL underline;
/**字体大小（不允许小数字体）*/
@property (nonatomic, assign) NSInteger fontSize;
/**字体颜色*/
@property (nonatomic,copy) UIColor *textColor;
/**字体*/
@property (nonatomic,copy) NSString* fontName;


+(instancetype)createDefualtStyle;

/**所有字体名称*/
+(NSArray<NSString*>*)styleAllFontName;
/**所有字体颜色*/
+(NSArray<UIColor*>*)styleAllColor;




@end
