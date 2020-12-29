//
//  HKAfterBaseTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterBaseTableViewCell.h"

@implementation HKAfterBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)afterBaseTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = NSStringFromClass([self class]);
    
    HKAfterBaseTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKAfterSaleRespone *)model{
    _model = model;
}
-(void)baseDirectRefund{
    //直接退款
    if ([self.delegate respondsToSelector:@selector(directRefund)]) {
        [self.delegate directRefund];
    }
}
-(void)baseApprovalArefund{
    //同意退款
    if ([self.delegate respondsToSelector:@selector(approvalArefund)]) {
        [self.delegate approvalArefund];
    }
}
-(void)baseRefusingArefund{
    //    拒绝退了
    if ([self.delegate respondsToSelector:@selector(refusingArefund)]) {
        [self.delegate refusingArefund];
    }
}
-(void)baseApprovalGoods{
    //同意退或
    if ([self.delegate respondsToSelector:@selector(approvalArefund)]) {
        [self.delegate approvalArefund];
    }
}
-(void)baseRefusingGoods{
    //    拒绝退货
    if ([self.delegate respondsToSelector:@selector(refusingArefund)]) {
        [self.delegate refusingArefund];
    }
}
-(void)baseTrackingLogistics{
    //    跟踪物流
    if ([self.delegate respondsToSelector:@selector(trackingLogistics)]) {
        [self.delegate trackingLogistics];
    }
}
-(void)baseProof{
    //    举证
    if ([self.delegate respondsToSelector:@selector(proof)]) {
        [self.delegate proof];
    }
}
@end
