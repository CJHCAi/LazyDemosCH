//
//  CCPCalendarModel.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/27.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarModel.h"
#import "NSObject+CCPObjc.h"

@implementation CCPCalendarModel
- (instancetype)initWithArray:(NSArray *)values {
    if (self = [super init]) {
        NSArray *names = [self getPropertyNames];
        [names enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setValue:values[idx] forKey:obj];
        }];
    }
    return self;
}
@end
