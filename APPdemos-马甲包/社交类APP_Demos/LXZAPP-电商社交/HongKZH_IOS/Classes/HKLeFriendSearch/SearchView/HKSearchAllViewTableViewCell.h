//
//  HKSearchAllViewTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSearchAllViewTableViewCellDelegate <NSObject>

@optional
- (void)searchFriend ;
- (void)seachMessage ;
- (void)searchcCicle ;
@end
@interface HKSearchAllViewTableViewCell : UITableViewCell
+(instancetype)searchAllViewTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKSearchAllViewTableViewCellDelegate> delegate;
@end
