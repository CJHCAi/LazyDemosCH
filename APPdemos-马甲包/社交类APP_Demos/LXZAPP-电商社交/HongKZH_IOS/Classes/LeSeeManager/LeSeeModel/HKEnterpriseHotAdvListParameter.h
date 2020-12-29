//
//  HKEnterpriseHotAdvListParameter.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKEnterpriseHotAdvListParameter : NSObject
@property (nonatomic,assign) int  pageNumber;
@property (nonatomic, copy)NSString *typeId;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end
