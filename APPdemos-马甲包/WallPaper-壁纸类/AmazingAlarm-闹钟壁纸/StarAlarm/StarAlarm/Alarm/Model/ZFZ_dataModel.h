//
//  ZFZ_dataModel.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/12.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFZ_dataModel : NSObject

@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;
@property (nonatomic, strong) NSString *week;
//@property (nonatomic, strong) NSString *nandu;
@property (nonatomic, strong) NSNumber *customId;
@property (nonatomic, strong) NSString *style;

- (instancetype)initWithDateSource:(NSDictionary *)dataSource;
@end
