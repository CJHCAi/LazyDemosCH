//
//  DateModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/23.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject
/** 年*/
@property (nonatomic, assign) NSInteger year;
/** 月*/
@property (nonatomic, assign) NSInteger month;
/** 日*/
@property (nonatomic, assign) NSInteger day;
/** 时*/
@property (nonatomic, assign) NSInteger hour;

-(instancetype)initWithDateStr:(NSString *)str;
@end
