//
//  HKAfterBaseTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAfterNode.h"
@class HKAfterSaleRespone;
@protocol HKAfterBaseTableViewCellDelagate <NSObject>

@optional
-(void)directRefund;//直接退款
-(void)approvalArefund;//同意退款退款
-(void)refusingArefund;//拒绝退款
-(void)trackingLogistics;//跟踪物流
-(void)proof;//举证
-(void)refusingGoods;//拒绝退货
-(void)approvalGoods;//同意退货
-(void)complainSellers; //投诉商家

@end
@interface HKAfterBaseTableViewCell : UITableViewCell
@property (nonatomic, strong)HKAfterSaleRespone *model;
+(instancetype)afterBaseTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKAfterBaseTableViewCellDelagate> delegate;
@property (nonatomic,assign) AfterSaleViewStatue staue;

-(void)baseDirectRefund;
-(void)baseApprovalArefund;
-(void)baseRefusingArefund;
-(void)baseTrackingLogistics;
-(void)baseProof;
-(void)baseRefusingGoods;
-(void)baseApprovalGoods;
@end
