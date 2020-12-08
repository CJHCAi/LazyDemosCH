//
//  LSYReadConfig.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSYReadConfig : NSObject<NSCoding>
+(instancetype)shareInstance;
/**
 *  设置字体大小
 */
@property (nonatomic) CGFloat fontSize;
/**
 *  设置行间距
 */
@property (nonatomic) CGFloat lineSpace;
/**
 *  设置字体颜色
 */

@property (nonatomic,strong) UIColor *fontColor;

/**
 *  设置主题颜色
 */
@property (nonatomic,strong) UIColor *theme;
@end
