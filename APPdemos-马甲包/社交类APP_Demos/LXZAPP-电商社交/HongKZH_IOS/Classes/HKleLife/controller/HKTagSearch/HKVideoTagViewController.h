//
//  HKVideoTagViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@protocol HKVideoTagViewControllerDelegate <NSObject>

@optional
-(void)tagClickBlock:(id)tagValue;

@end
@interface HKVideoTagViewController : HK_BaseView

@property (nonatomic,weak) id<HKVideoTagViewControllerDelegate> delegate;

@end
