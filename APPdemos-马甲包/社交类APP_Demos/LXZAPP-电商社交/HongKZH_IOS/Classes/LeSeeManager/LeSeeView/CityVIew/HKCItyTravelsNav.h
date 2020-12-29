//
//  HKCItyTravelsNav.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NavBackBlock)(void);
@interface HKCItyTravelsNav : UIView
@property (nonatomic, copy)NavBackBlock backBlock;
+(instancetype)cItyTravelsNavWIthBack:(NavBackBlock)backBlock;
@end
