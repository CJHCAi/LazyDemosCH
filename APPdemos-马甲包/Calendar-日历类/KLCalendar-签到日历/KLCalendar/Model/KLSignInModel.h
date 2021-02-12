//
//  KLSignInModel.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLSignInModel : NSObject

@property (nonatomic, copy) NSString *continuous;

@property (nonatomic, copy) NSString *integral;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *currentday;

@property (nonatomic, copy) NSString *weekday;

@property (nonatomic, strong) NSMutableArray *monthSignArray;

- (instancetype)initWithSignInDataDict:(NSDictionary *)dict;
+ (instancetype)dataWithSignInDict:(NSDictionary *)dict;

@end

@interface KLMonthSign : NSObject

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *sign;

- (instancetype)initWithMonthSignDataDict:(NSDictionary *)dict;
+ (instancetype)dataWithMonthSignDict:(NSDictionary *)dict;
@end