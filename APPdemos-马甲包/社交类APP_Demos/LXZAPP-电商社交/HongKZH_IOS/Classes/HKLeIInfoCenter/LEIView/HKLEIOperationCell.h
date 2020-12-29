//
//  HKLEIOperationCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKLEIOperationModel,HKMyDataRespone;
@interface HKLEIOperationCell : UITableViewCell
+(instancetype)lEIOperationCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKLEIOperationModel *dataModel;
@property (nonatomic, strong)HKMyDataRespone *respone;

-(void)configueRecuitCell;

@end
