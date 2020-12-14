//
//  CheckinModel.m
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/12.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import "CheckinModel.h"

@implementation CheckinModel
+ (id)initWithDic:(NSDictionary *)dic
{
    CheckinModel *model = [[CheckinModel alloc] init];
    model.flightCode = dic[@"flightCode"];
    model.flightUrl = dic[@"flightUrl"];
    model.flightName = dic[@"flightName"];
    model.flightPhone = dic[@"flightPhone"];
    model.flightTimeAndRule = dic[@"flightTimeAndRule"];
    
    return model;
}
@end
