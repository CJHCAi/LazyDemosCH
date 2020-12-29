//
//  HKMyFriendTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKFriendRespond.h"

@protocol PushUserBaseInfoDelegete <NSObject>

-(void)pushUserDetailControllerWithModel:(HKFriendModel *)model;

@end

@interface HKMyFriendTableViewCell : UITableViewCell
@property (nonatomic, strong)HKFriendModel *friendM;
@property (nonatomic, weak)id <PushUserBaseInfoDelegete>delegete;
+(instancetype)myFriendTableViewCellWithTableView:(UITableView*)tableView;
@end
