//
//  HK_MediaMainAllCategoryModelData.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_MediaMainAllCategoryModelData : BaseModel
@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;
@end
