//
//  UIColor+BFColor.h
//  codePackage
//
//  Created by 周冰烽 on 2017/7/5.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BFColor)
/*随机颜色*/
+(instancetype)BF_RandomColor;

/*RGB颜色*/
+(instancetype)BF_Red:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

/*16进制颜色*/
+(instancetype)BF_ColorWithHex:(uint32_t)hex;

@end
