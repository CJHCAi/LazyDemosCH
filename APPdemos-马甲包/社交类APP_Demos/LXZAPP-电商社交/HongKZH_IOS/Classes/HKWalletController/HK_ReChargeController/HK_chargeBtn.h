//
//  HK_chargeBtn.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_ChargeModel.h"

@protocol chargeViewClickDelegete <NSObject>

-(void)clickChageV:(HK_ChargeModel *)model;


@end

@interface HK_chargeBtn : UIView

@property (nonatomic, strong)UILabel * CoinLabel;
@property (nonatomic, strong)UILabel * RmbLabel;
@property (nonatomic, strong)HK_ChargeModel * mdoel;
@property (nonatomic, weak)id<chargeViewClickDelegete>delegete;
@end
