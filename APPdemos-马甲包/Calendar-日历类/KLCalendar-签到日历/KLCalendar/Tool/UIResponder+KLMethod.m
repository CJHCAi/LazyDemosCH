//
//  UIResponder+KLMethod.m
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import "UIResponder+KLMethod.h"

@implementation UIResponder (KLMethod)
//参数为空处理返回值不是数字
+(NSString *)isNullClassDataString:(NSString *)dataString{
    if (![dataString isKindOfClass:[NSNull class]]&&(dataString.length > 0)) {
        return dataString;
    }else{
        return @"";
    }
}

//参数为空处理返回值是数字
+(NSString *)isNullNumberDataString:(NSString *)numbertring{
    
    NSString *str = [NSString stringWithFormat:@"%@",numbertring];
    
    if ((![str isKindOfClass:[NSNull class]])&&(![str isEqualToString:@""])) {
        return str;
    }else if(str.length == 0){
        str = @"";
        return str;
    }else{
        return @"0";
    }
}

//数组为空处理
+(NSArray *)isNullClassDataArray:(NSArray *)dataArray{
    if (![dataArray isKindOfClass:[NSNull class]]) {
        return dataArray;
    }else{
        NSArray *array = [NSArray array];
        return array;
    }
}

@end
