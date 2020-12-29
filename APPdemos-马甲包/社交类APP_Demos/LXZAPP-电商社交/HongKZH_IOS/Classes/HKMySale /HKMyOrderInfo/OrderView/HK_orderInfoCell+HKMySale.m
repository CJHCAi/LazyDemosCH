//
//  HK_orderInfoCell+HKMySale.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderInfoCell+HKMySale.h"
#import <objc/runtime.h>
static char *infoModelKey = "infoModel";
@implementation HK_orderInfoCell (HKMySale)
- (void)setInfoModel:(HKOrderInfoData *)infoModel {
    
    objc_setAssociatedObject(self, &infoModelKey, infoModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
        self.orderNumberLabel.text  = infoModel.orderNumber;
        self.orderTimeLabel.text = infoModel.createDate;
        self.payTool.text = infoModel.payType;
        self.payTimeLabel.text = infoModel.payTime;
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld",infoModel.productIntegral] ;
        self.transFeeLabel.text = [NSString stringWithFormat:@"%ld",infoModel.freightIntegral] ;
        self.payTotalLabel.text = [NSString stringWithFormat:@"%ld",infoModel.freightIntegral+infoModel.productIntegral] ;
    
}

- (NSString *)infoModel {
    
    return objc_getAssociatedObject(self, &infoModelKey);
}

@end
