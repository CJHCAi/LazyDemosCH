//
//  HKFreindCollageView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCounponTool.h"
@protocol HKFreindCollageViewDelegate <NSObject>

@optional
-(void)collageBlock;

@end
@interface HKFreindCollageView : UIView
@property (nonatomic,weak) id<HKFreindCollageViewDelegate> delegate;
@property (nonatomic, strong)HKCollageOrderResponse *response;

@end
