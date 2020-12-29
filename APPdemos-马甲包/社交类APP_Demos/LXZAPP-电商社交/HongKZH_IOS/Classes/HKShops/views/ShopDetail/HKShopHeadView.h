//
//  HKShopHeadView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKShopTool.h"
typedef void(^saveBlock)(HKShopResponse *response);

@protocol sectionClickDelegete <NSObject>

-(void)pushHomeWithIndex:(NSInteger)index;
-(void)saveBlock:(HKShopResponse*)response;
@end

@interface HKShopHeadView : UIView

@property (nonatomic, strong)HKShopResponse *response;
@property (nonatomic, strong)HKShopInfo *info;
@property (nonatomic, strong)UIButton *saveBtn;
@property (nonatomic, weak)id<sectionClickDelegete>delegete;

@end
