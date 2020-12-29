//
//  HKContactTheBuyerTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKContactTheBuyerTableViewCellDeleagte <NSObject>

@optional
-(void)contactTheBuyer;

@end
@interface HKContactTheBuyerTableViewCell : UITableViewCell
+(instancetype)contactTheBuyerTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKContactTheBuyerTableViewCellDeleagte> delegate;
@end
