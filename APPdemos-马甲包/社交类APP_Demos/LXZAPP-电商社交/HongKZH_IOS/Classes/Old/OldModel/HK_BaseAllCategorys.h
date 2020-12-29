//
//  HK_BaseAllCategorys.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_BaseAllCategorys : BaseModel

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic,assign) BOOL isUpdateCategory;
@end
