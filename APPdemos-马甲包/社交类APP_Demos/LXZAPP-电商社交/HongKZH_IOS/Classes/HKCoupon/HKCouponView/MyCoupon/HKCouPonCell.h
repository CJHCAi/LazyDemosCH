//
//  HKCouPonCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCouponResponse.h"
#import "HKDisCutResponse.h"
#import "HKBVipCopunResponse.h"
@protocol CounDetailDelegete <NSObject>

@optional
-(void)setClickDelegeteWithModel:(HKCounList *)model andSender:(NSInteger)index WithNSIndexPath:(NSIndexPath *)path;
//拼单成功 猜你喜欢列表..
@end
@interface HKCouPonCell : UITableViewCell
@property (nonatomic, strong)HKCounList * model;
@property (nonatomic, strong)HKDisCutList *list;
@property (nonatomic, strong)HKVipData  *vipData;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, weak) id <CounDetailDelegete>delegete;
-(void)setSuccessCell;
@end
