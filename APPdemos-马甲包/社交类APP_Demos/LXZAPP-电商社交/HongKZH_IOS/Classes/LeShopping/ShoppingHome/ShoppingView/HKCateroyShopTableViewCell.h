//
//  HKCateroyShopTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKCateroyShopTableViewCellDelegate <NSObject>

@optional
-(void)selectShop:(NSIndexPath*)indexPath;
@end
@interface HKCateroyShopTableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic,weak) id<HKCateroyShopTableViewCellDelegate> delegate;
@end
