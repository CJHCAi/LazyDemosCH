//
//  HKSelectFreightProCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKShopDataInitRespone.h"
typedef void(^ShowOrHide)(void);
typedef void(^SelectBlcok)(MediaareasInits*model,BOOL isSelect);
@protocol HKSelectFreightProCellDelegate <NSObject>

@optional
-(void)selectModel:(MediaareasInits*)model isSelect:(BOOL)isSelct;
@end
@interface HKSelectFreightProCell : BaseTableViewCell
@property (nonatomic, strong)MediaareasInits *model;
@property (nonatomic,assign) int selectType;
@property (nonatomic, copy)ShowOrHide block;
@property (nonatomic, copy)SelectBlcok selectBlcok;
@property(nonatomic, assign) BOOL isSelcted;
@property (nonatomic,weak) id<HKSelectFreightProCellDelegate> delegate;
@property (nonatomic,assign) BOOL isNewSelect;
@end
