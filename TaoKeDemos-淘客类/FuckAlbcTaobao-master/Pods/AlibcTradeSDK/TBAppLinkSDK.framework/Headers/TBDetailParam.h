//
//  TBDetailParam.h
//  WopcMiniSDK
//
//  Created by muhuai on 15/8/18.
//  Copyright (c) 2015年 TaoBao. All rights reserved.
//

#import "TBBasicParam.h"

@interface TBDetailParam : TBBasicParam
/**
 *  itemId,要跳转到的商品
 */
@property (nonatomic, strong) NSString     *itemId;

/**
 *  初始化,itemId(必传)
 *
 *  @param itemId
 */
-(instancetype)initWithItemId:(NSString *)itemId;

@end
