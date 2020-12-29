//
//  HKFriendAttentionCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMediaInfoResponse.h"

@protocol AttentionFllowDelegete <NSObject>

-(void)pushUserDetailWithModel:(HKmediaInfoFollows *)model;
@end

@interface HKFriendAttentionCell : UITableViewCell
@property (nonatomic, strong)HKMediaInfoResponse *response;
@property (nonatomic, weak)id<AttentionFllowDelegete>delegete;
@end
