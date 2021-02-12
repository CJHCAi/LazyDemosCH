//
//  KLSignInModel.m
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import "KLSignInModel.h"
#import "UIResponder+KLMethod.h"

@implementation KLSignInModel
- (instancetype)initWithSignInDataDict:(NSDictionary *)dict {
    if (self == [super init]) {
        _continuous = [UIResponder isNullNumberDataString:[dict objectForKey:@"continuous"]];
        _integral = [UIResponder isNullNumberDataString:[dict objectForKey:@"integral"]];
        _month = [UIResponder isNullNumberDataString:[dict objectForKey:@"month"]];
        _currentday = [UIResponder isNullNumberDataString:[dict objectForKey:@"currentDay"]];
        _weekday = [UIResponder isNullNumberDataString:[dict objectForKey:@"weekday"]];
        NSMutableArray *mutArr = [dict objectForKey:@"monthSign"];
        // 字典数组转模型数组
        _monthSignArray = [NSMutableArray arrayWithCapacity:31];
        KLMonthSign *monthSignModel = [[KLMonthSign alloc] init];
        for (int i = 0; i < mutArr.count; i++) {
            monthSignModel = [KLMonthSign dataWithMonthSignDict:mutArr[i]];
            
            [_monthSignArray addObject:monthSignModel];
        }
        
    }
    return self;
}

+ (instancetype)dataWithSignInDict:(NSDictionary *)dict {
    return [[self alloc] initWithSignInDataDict:dict];
}

@end

@implementation KLMonthSign

- (instancetype)initWithMonthSignDataDict:(NSDictionary *)dict {
    if (self == [super init]) {
        _day=[UIResponder isNullNumberDataString:[dict objectForKey:@"day"]];
        _sign=[UIResponder isNullNumberDataString:[dict objectForKey:@"sign"]];
    }
    return self;
}

+ (instancetype)dataWithMonthSignDict:(NSDictionary *)dict {
    return [[self alloc] initWithMonthSignDataDict:dict];
}

@end