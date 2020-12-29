//
//  HKAddressTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAddressListRespone.h"
@protocol HKAddressTableViewCellDelegate <NSObject>

@optional
-(void)gotEditAddressWithModel:(HKAddressModel*)address;

@end
@interface HKAddressTableViewCell : UITableViewCell
+(instancetype)addressTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKAddressModel *address;

@property (nonatomic,weak) id<HKAddressTableViewCellDelegate> delegate;

@property (nonatomic,assign) BOOL isRight;
@end
