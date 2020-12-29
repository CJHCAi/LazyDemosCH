//
//  HKMySaleViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKMySaleRespone.h"
@interface HKMySaleViewModel : NSObject
+(void)loadMySale:(NSDictionary*)dict success:(void (^)( HKMySaleRespone* responde))success;
@end
