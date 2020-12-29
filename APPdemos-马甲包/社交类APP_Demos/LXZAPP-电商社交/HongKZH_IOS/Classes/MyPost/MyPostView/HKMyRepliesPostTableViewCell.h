//
//  HKMyRepliesPostTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyRepliesPostsRespone.h"
#import "HKMyDelPostsRespne.h"
@interface HKMyRepliesPostTableViewCell : UITableViewCell
+(instancetype)myRepliesPostTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)MyRepliesPostsModel *model;
@property (nonatomic, strong)HKMyDelPostsModel *delModel;
@end
