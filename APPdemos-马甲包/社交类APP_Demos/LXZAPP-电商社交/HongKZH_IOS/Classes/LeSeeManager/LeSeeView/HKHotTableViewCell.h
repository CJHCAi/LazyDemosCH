//
//  HKHotTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKHotTableViewCellDelegate <NSObject>

@optional
-(void)clickHot:(NSInteger)tag;

@end

@interface HKHotTableViewCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *dataArray;
+(instancetype)hotTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKHotTableViewCellDelegate> delegate;
@end
