//
//  CCPCalendarModel.h
//  CCPCalendar
//
//  Created by Ceair on 17/5/27.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPCalendarModel : NSObject

//yyyy-MM-dd
@property (nonatomic, strong) NSString *ccpDate;
//yyyy
@property (nonatomic, strong) NSString *year;
//MM
@property (nonatomic, strong) NSString *month;
//dd
@property (nonatomic, strong) NSString *day;
//中文 周几
@property (nonatomic, strong) NSString *weekString;
//周几 0表示周日
@property (nonatomic, assign) NSInteger week;

- (instancetype)initWithArray:(NSArray *)values;

@end
