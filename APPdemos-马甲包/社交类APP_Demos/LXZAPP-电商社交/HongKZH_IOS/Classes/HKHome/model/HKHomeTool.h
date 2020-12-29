//
//  HKHomeTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKReconmendBaseResponse.h"
#import "WaterFLayout.h"
#import "HKMyVideoCell.h"
@interface HKHomeTool : NSObject

/**
 *  获取推荐页信息
 */
+(void)getRecomendListWithPage:(NSInteger)page SuccessBlock:(void(^)(HKReconmendBaseResponse *response))response fail:(void(^)(NSString *error))error;



@end
