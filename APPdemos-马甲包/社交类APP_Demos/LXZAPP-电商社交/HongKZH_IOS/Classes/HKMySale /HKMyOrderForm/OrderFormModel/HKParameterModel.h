//
//  HKParameterModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKParameterModel : NSObject
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,assign) int pageNum;
@property(nonatomic, assign) CGPoint point;
@end
