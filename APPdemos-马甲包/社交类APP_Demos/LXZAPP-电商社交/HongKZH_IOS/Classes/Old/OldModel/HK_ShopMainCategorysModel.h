//
//  HK_ShopMainCategorysModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_ShopMainCategorysModel : BaseModel
@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, strong) BaseModel *rootProducts;
@end
