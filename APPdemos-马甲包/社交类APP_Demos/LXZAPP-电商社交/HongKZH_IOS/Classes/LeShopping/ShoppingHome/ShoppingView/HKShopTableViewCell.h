//
//  HKShopTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol PushShopInfoDelegete <NSObject>

-(void)enterShopDetail:(NSString *)shopId;
@end

@interface HKShopTableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, weak)id<PushShopInfoDelegete>delegete;
@end
