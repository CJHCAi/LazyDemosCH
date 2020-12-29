//
//  RHKeasonsRejectionTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RHKeasonsRejectionTableViewCellDelegate <NSObject>

@optional
-(void)isSubmission:(NSString*)refundReason;
@end
@interface RHKeasonsRejectionTableViewCell : UITableViewCell
+(instancetype)keasonsRejectionTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<RHKeasonsRejectionTableViewCellDelegate> delegate;
@property(nonatomic, assign) AfterSaleViewStatue staue;
@end
