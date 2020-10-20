//
//  SXTBaseHandler.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  处理完成事件
 */
typedef void(^CompleteBlock)();

/**
 *  处理事件成功
 *
 *  @param obj 返回数据
 */
typedef void(^SuccessBlock)(id obj);

/**
 *  处理事件失败
 *
 *  @param obj 错误信息
 */

typedef void(^FailedBlock)(id obj);

@interface SXTBaseHandler : NSObject


@end
