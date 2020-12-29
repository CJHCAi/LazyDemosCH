//
//  HKUserEnergyTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKUserEnergyTableViewCellDelegate <NSObject>

@optional
-(void)friendsHelp;//邀请好友
-(void)helpFriends;
-(void)gotoHelpFriendList;
@end
@class HKluckyBurstDetailRespone;
@interface HKUserEnergyTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKluckyBurstDetailRespone *respone;
@property (nonatomic,weak) id<HKUserEnergyTableViewCellDelegate> delegate;
@end
