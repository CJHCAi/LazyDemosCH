//
//  HKSearchTagController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

typedef  void(^searchTag)(id tagValue);

@interface HKSearchTagController : HK_BaseView

@property (nonatomic, copy) searchTag stBlock;

@end
