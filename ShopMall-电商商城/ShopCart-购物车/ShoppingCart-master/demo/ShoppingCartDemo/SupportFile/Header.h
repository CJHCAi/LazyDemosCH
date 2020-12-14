//
//  Header.h
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#ifndef Header_h
#define Header_h

//尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIPhoneXBottomHeight ((kScreenHeight == 812)?34:0) //iPhoneX底部留出34距离

//项目常用颜色值
#define WHITE_COLOR                 [UIColor whiteColor]                 //白色
#define WORD_COLOR                  [UIColor colorWithHex:@"666666"]     //一般字体颜色
#define RED_COLOR                   [UIColor colorWithHex:@"ff4c4b"]     //红色
#define LINE_COLOR                  [UIColor colorWithHex:@"f5f5f5"]     //线条颜色


//快捷赋值
#define ImgName(imageName) [UIImage imageNamed:imageName]

//
#define kWeakSelf(type)__weak typeof(type)weak##type = type;
#define kStrongSelf(type)__strong typeof(type)type = weak##type;

#import "DDCategory.h"
#import "DDButton.h"
#import "DDLabel.h"

#endif /* Header_h */
