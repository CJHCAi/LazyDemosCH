//
//  HK_FriendUserVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKMyFriendListViewModel.h"
@protocol UpdateHeaderDataDelegete <NSObject>

-(void)updateUserHeaderInfoWith:(HKMediaInfoResponse *)response;

@end

@interface HK_FriendUserVc : HK_BaseView

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, weak)id <UpdateHeaderDataDelegete>delegete;

@end
