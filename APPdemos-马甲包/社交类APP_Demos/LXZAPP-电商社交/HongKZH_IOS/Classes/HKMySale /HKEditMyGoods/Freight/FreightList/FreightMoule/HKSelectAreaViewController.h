//
//  HKSelectAreaViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKFreightListRespone.h"
typedef void(^SelectSuccess)(NSArray *areaArray,NSObject *model);
@interface HKSelectAreaViewController : HKBaseViewController
@property (nonatomic, strong)NSArray *areaArray;
@property (nonatomic, copy)SelectSuccess sucess;
@property (nonatomic, strong)NSObject *model;
+(void)showSelectVc:(HKBaseViewController*)subVc freightListSublist:(NSObject*)model selectArray:(NSArray*)selectArray selectNewArray:(NSString*)selectNewString success:(SelectSuccess)success;
-(void)initNewSelectData:(NSString*)idString;
@end
