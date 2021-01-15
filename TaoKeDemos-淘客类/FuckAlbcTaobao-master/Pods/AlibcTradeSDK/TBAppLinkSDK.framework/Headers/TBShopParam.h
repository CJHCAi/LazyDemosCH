//
//  TBShopParam.h
//  WopcMiniSDK
//
//  Created by muhuai on 15/8/18.
//  Copyright (c) 2015年 TaoBao. All rights reserved.
//

#import "TBBasicParam.h"

@interface TBShopParam : TBBasicParam

/**
 *  shopId,要跳转到的店铺
 */
@property (nonatomic, strong) NSString *shopId;

/**
 *  初始化,shopId必传
 *
 *  @param shopId
 */
-(instancetype)initWithShopId:(NSString *)shopId;

@end
