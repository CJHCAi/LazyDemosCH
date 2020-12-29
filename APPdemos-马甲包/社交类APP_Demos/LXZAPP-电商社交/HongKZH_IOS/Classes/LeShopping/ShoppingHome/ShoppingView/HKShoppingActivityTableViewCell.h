//
//  HKShoppingActivityTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKShoppingActivityTableViewCellDelegate <NSObject>

@optional
-(void)gotoDetailsWithID:(NSString*)productId;
-(void)gotoMore;
@end
@interface HKShoppingActivityTableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSArray * selectedProducts;
@property(nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic,weak) id<HKShoppingActivityTableViewCellDelegate> delegate;
@end
