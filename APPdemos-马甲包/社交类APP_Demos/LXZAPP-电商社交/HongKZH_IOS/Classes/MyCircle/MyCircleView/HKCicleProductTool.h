//
//  HKCicleProductTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCicleProductResponse.h"
@protocol BottomClickDelegete <NSObject>

-(void)SeverBtnClick:(NSInteger)index;

@end

@interface HKCicleProductTool : UIView

@property (nonatomic, weak)id<BottomClickDelegete>delegete;
@property (nonatomic, strong)HKCicleProductResponse *response;
@property (nonatomic, assign)NSInteger num;
@end
