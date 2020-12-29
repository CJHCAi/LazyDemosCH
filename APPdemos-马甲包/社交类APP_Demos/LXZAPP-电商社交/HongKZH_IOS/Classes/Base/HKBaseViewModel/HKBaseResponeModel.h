//
//  HKBaseResponeModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKBaseResponeModel : NSObject
@property (nonatomic, copy)NSString *msg;
@property(nonatomic, copy) NSString * code;
@property (nonatomic, strong)NSObject *data;
@property (nonatomic,assign) BOOL responeSuc;
@end
