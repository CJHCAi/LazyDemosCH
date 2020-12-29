//
//  HKApplicationRefundTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterBaseTableViewCell.h"
#import "HKLineBtn.h"
@interface HKApplicationRefundTableViewCell : HKAfterBaseTableViewCell

@property (weak, nonatomic) IBOutlet HKLineBtn *leftBtn;

@property (weak, nonatomic) IBOutlet HKLineBtn *rightBtn;
@property (weak, nonatomic) IBOutlet HKLineBtn *agree;

@property (weak, nonatomic) IBOutlet UILabel *TitleMessageLabel;
//买家 取消退款
-(void)cancelRefund;

//买家 修改 底部按钮标题和是否隐藏
-(void)changeBarStatus;

@end
