//
//  HKHostItemView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HkHotRespone.h"
@protocol HKHostItemViewDelegate <NSObject>

@optional
-(void)itemClick:(NSInteger)tag;

@end
@interface HKHostItemView : UIView
@property (nonatomic, strong)HKHotModel *model;
@property (nonatomic,weak) id<HKHostItemViewDelegate> delegate;
@end
