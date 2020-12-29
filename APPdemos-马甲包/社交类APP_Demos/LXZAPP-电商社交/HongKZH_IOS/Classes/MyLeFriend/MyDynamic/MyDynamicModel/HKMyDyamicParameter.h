//
//  HKMyDyamicParameter.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKMyDyamicParameter : NSObject
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int pageNumber;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end
