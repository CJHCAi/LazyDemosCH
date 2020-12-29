//
//  HKBurstingAtivityFriendTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKLuckyBurstListRespone.h"
@protocol HKBurstingAtivityFriendTableViewCellDelegate <NSObject>

@optional
-(void)burstingAtivityFriendClick;

@end
@interface HKBurstingAtivityFriendTableViewCell : BaseTableViewCell
@property(nonatomic, assign) int type;
@property (nonatomic, strong) LuckyBurstListFriend *model;
@property (nonatomic,weak) id<HKBurstingAtivityFriendTableViewCellDelegate> delegate;
@end
