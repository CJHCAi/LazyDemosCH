//
//  SXTSureOrderModel.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTSureOrderModel.h"

@implementation SXTSureOrderModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"PayList" : @"SXTOrderPayListModel",
             @"GoodsList" : @"SXTOrderListModel"
             };
}
@end
