//
//  HKAddFriendTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRecommendFansModel.h"
@protocol HKAddFriendTableViewCellDelegate <NSObject>

@optional
-(void)attentionSomeOneWithModel:(FriendList *)model andIndexPath:(NSIndexPath *)path;

-(void)pushUserDetail:(FriendList *)model;

@end
@interface HKAddFriendTableViewCell : UITableViewCell
+(instancetype)addFriendCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)FriendList *friendM;
@property (nonatomic,weak) id<HKAddFriendTableViewCellDelegate> delegate;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end
