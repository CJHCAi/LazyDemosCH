//
//  Header.h
//  ShrinkageTB
//
//  Created by xxlc on 2019/6/25.
//  Copyright © 2019 yunfu. All rights reserved.
//

#ifndef Header_h
#define Header_h



//16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//背景颜色
//自定义透明度的RGB
#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 1.0]
#define BackGroundColor RGBA(245, 246, 250,1.0)
/**
 *  比例系数适配
 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define m6Scale               kScreenWidth/750.0

#import "Masonry.h"





#endif /* Header_h */
