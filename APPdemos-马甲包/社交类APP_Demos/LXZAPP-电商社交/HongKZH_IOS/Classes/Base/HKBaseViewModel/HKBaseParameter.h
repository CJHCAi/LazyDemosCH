//
//  HKBaseParameter.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef enum{
    ParameterType_Recruit = 0,//招聘
    ParameterType_CircleC = 1
}ParameterType;
@interface HKBaseParameter : NSObject
@property (nonatomic,assign) int pageNumber;
@property (nonatomic,assign) ParameterType parameterType;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property(nonatomic, assign) int staueType;
@property (nonatomic, copy)NSString *sortId;
@property (nonatomic, copy)NSString *sortValue;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic,assign) BOOL isAsc;
@end
