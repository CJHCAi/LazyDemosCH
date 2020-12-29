//
//  HKAdvertisingTypeTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CorporateCategoryResponse;
@protocol HKAdvertisingTypeTableViewCellDelegate <NSObject>

@optional
-(void)tableViewRefresh;
-(void)selectCategory:(NSString*)ID index:(NSInteger)index;
@end
@interface HKAdvertisingTypeTableViewCell : BaseTableViewCell
@property (nonatomic, strong)CorporateCategoryResponse *model;
@property (nonatomic,weak) id<HKAdvertisingTypeTableViewCellDelegate> delegate;

@property(nonatomic, assign) NSInteger currentIndex;
@end
