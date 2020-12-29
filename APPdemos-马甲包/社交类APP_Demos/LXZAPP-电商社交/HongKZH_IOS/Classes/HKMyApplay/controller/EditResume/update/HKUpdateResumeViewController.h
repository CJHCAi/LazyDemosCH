//
//  HKUpdateResumeViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef void(^UpdateCompleteBlock)(NSString *complete);

@interface HKUpdateResumeViewController : HK_BaseView

@property (nonatomic, copy)  UpdateCompleteBlock block;

@end
