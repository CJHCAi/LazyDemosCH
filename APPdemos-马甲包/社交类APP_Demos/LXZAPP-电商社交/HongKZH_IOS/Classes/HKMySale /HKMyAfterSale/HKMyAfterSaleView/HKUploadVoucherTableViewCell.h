//
//  HKUploadVoucherTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKUploadVoucherTableViewCellDelegate <NSObject>

@optional
-(void)dataUpdatedWithIndex:(NSInteger)index;
@end
@interface HKUploadVoucherTableViewCell : UITableViewCell
+(instancetype)uploadVoucherTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKUploadVoucherTableViewCellDelegate> delegate;

@property (nonatomic, strong)NSMutableArray *imageArray;

@property(nonatomic, assign) AfterSaleViewStatue staue;
@end
