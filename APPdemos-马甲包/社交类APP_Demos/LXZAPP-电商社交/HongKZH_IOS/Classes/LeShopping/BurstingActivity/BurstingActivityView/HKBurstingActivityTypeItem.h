//
//  HKBurstingActivityTypeItem.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLuckyBurstRespone.h"
@protocol HKBurstingActivityTypeItemDelegate <NSObject>

@optional
-(void)btnClick:(NSInteger)tag;
@end
@interface HKBurstingActivityTypeItem : UIView
@property (nonatomic, strong)LuckyBurstTypes *model;
@property (nonatomic,weak) id<HKBurstingActivityTypeItemDelegate> delegate;
@end
