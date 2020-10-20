//
//  NSString+md5.h
//  测试接口
//
//  Created by 姚珉 on 16/5/23.
//  Copyright © 2016年 yaomin. All rights reserved.
//

typedef enum : NSUInteger {
    md5CodingTypeUploadImage,
    md5CodingTypeOther,
    md5CodingTypeUploadArr
} md5CodingType;


#import <Foundation/Foundation.h>


@interface NSString (md5)
+(NSString *) md5Str:(NSString *)str;
//字典装字符串
+(NSString *) stringWithDic:(NSDictionary *)dic type:(md5CodingType)codingType;
+(NSString *)getCurrentTimeAddNumber;
//横向转竖向字符串
+(NSString *)verticalStringWith:(NSString *)string;

//json字典转字典
+(NSDictionary *)jsonDicWithDic:(NSDictionary *)dic;

//json数组转数组
+(NSArray*)jsonArrWithArr:(NSArray *)arr;
@end
