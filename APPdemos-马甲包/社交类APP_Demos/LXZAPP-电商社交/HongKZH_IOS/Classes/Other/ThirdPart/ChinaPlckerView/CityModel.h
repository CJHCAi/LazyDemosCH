//
//  CityModel.h
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
/**
 *  GRADE
 */
@property (nonatomic,copy)NSString *GRADE;
/**
 *  城市ID
 */
@property (nonatomic,copy)NSString *ID;
/**
 *  城市名
 */
@property (nonatomic,copy)NSString *NAME;
/**
 *  城市的上一级ID
 */
@property (nonatomic,copy)NSString *PARENT_AREA_ID;
@end
