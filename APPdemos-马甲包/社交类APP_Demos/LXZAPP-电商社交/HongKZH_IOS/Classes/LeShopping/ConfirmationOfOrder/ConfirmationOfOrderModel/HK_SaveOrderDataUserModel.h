//
//  HK_SaveOrderDataUserModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseModel.h"

@interface HK_SaveOrderDataUserModel : HK_BaseModel
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) double integral;; //乐币

@property (nonatomic, copy) NSString *name;
@end
