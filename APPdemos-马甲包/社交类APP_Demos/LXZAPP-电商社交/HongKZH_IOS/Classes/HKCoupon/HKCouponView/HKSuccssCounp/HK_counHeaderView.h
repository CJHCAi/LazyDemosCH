//
//  HK_counHeaderView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCollageOrderResponse.h"
@protocol counHeaderViewDelegete <NSObject>

@optional

-(void)justForSaleCoun ;
-(void)JustForUSeCoun ;

@end
@interface HK_counHeaderView : UIView

@property (nonatomic, weak)id<counHeaderViewDelegete>delegete;

@property (nonatomic, strong)HKCollageOrderResponse *response;


@end
