//
//  HKSelectbaseViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
typedef enum{
   HKSelectbaseType_position = 0,
    HKSelectbaseType_city = 1,
    HKSelectbaseType_salary = 2
} HKSelectbaseType;
@protocol HKSelectbaseViewControllerDelegate <NSObject>

@optional
-(void)gotoVc:(NSMutableArray*)array type:(HKSelectbaseType)type;
@end

@interface HKSelectbaseViewController : HKBaseViewController
@property (nonatomic,assign) HKSelectbaseType type;
@property (nonatomic,weak) id<HKSelectbaseViewControllerDelegate> delegate;
@end
