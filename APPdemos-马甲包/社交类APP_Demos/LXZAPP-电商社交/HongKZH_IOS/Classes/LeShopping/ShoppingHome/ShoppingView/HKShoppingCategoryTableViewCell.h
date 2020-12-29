//
//  HKShoppingCategoryTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class HKLeShopHomeCategoryes;
@protocol HKShoppingCategoryTableViewCellDelegate <NSObject>

@optional
-(void)gotoCategryVC:(HKLeShopHomeCategoryes*)itemM;

@end
@interface HKShoppingCategoryTableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic,weak) id<HKShoppingCategoryTableViewCellDelegate> delegate;
@end
