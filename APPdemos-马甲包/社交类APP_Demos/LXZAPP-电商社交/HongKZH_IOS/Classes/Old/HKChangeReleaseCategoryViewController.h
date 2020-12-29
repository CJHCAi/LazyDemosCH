//
//  HKChangeReleaseCategoryViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
@protocol HKChangeReleaseCategoryViewControllerDelegate <NSObject>

@optional
-(void)selectCategoty:(HK_BaseAllCategorys*)model;

@end
@interface HKChangeReleaseCategoryViewController : HK_BaseView
@property (nonatomic,assign) BOOL isClicle;
@property (nonatomic,weak) id<HKChangeReleaseCategoryViewControllerDelegate> delegate;
@property (nonatomic, strong)HK_BaseAllCategorys *selectModel;
@end
