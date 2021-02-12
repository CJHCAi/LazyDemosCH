//
//  CheckinModel.h
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/12.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckinModel : NSObject
@property (nonatomic, copy) NSString *flightCode; // 航空公司二字码，
@property (nonatomic, copy) NSString *flightUrl; // 跳转链接
@property (nonatomic, copy) NSString *flightName;
@property (nonatomic, copy) NSString *flightPhone;
@property (nonatomic, copy) NSString *flightTimeAndRule;

+ (id)initWithDic:(NSDictionary *)dic;
@end
