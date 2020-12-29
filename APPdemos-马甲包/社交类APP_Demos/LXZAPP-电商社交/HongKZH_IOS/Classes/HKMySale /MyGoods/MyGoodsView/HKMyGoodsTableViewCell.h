//
//  HKMyGoodsTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyGoodsRespone.h"
@protocol HKMyGoodsTableViewCellDelegate <NSObject>


-(void)gotoEditWithModel:(HKMyGoodsModel*)goodsM indexPath:(NSIndexPath*)indexpath;
-(void)gotoUpperLowerProductWithModel:(HKMyGoodsModel*)goodsM indexPath:(NSIndexPath*)indexpath state:(int)state;
-(void)shareWithModel:(HKMyGoodsModel*)model;
@end
@interface HKMyGoodsTableViewCell : UITableViewCell
+(instancetype)myGoodsTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKMyGoodsModel *goodsM;
@property (nonatomic,assign) int type;
@property (nonatomic,weak) id<HKMyGoodsTableViewCellDelegate> delegate;
@property (nonatomic,weak) NSIndexPath *indexPath;

@property (nonatomic,assign) int showType;
@end
