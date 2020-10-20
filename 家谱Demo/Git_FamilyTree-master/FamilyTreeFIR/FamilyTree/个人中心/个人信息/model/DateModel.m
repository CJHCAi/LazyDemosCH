//
//  DateModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/23.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "DateModel.h"

@implementation DateModel
-(instancetype)initWithDateStr:(NSString *)str{
    self = [super init];
    if (self) {
        self.year = [[str substringWithRange:NSMakeRange(0, 4)] intValue];
        self.month = [[str substringWithRange:NSMakeRange(5, 2)] intValue];
        self.day = [[str substringWithRange:NSMakeRange(8, 2)] intValue];
        self.hour = [[str substringWithRange:NSMakeRange(11, 2)] intValue];
    }
    return self;
}

@end
