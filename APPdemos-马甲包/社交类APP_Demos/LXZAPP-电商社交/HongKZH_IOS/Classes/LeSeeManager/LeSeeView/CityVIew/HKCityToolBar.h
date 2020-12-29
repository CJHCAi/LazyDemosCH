//
//  HKCityToolBar.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCityTravelsRespone.h"
@protocol CityBarDelegete <NSObject>

-(void)ClickSender:(UIButton *)sender andSenderTag:(NSInteger)tag;

@end
@interface HKCityToolBar : UIView
@property (nonatomic, weak)id <CityBarDelegete>delegete;
@property (nonatomic, strong)HKCityTravelsRespone *response;
@end
