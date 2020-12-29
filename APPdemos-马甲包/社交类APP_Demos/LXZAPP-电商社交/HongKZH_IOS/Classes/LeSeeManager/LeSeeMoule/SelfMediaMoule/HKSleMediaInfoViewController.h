//
//  HKSleMediaInfoViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKSleMediaInfoViewController : HKBaseViewController
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, assign)NSInteger type;


-(void)getNewLocationData;

@end
