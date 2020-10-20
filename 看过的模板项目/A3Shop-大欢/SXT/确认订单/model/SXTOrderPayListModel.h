//
//  SXTOrderPayListModel.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTOrderPayListModel : NSObject
/**支付方式*/
@property (copy, nonatomic) NSString *Distribution;
/**支付名字*/
@property (copy, nonatomic) NSString *DistributionName;
@end
