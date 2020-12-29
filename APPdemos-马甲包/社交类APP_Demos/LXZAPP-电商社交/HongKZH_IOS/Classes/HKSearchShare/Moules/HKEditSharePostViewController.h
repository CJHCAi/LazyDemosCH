//
//  HKEditSharePostViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKMyPostsRespone.h"
@protocol HKEditSharePostViewControllerDelegate <NSObject>

@optional
-(void)gotoBack;
@end
@interface HKEditSharePostViewController : HKBaseViewController
@property (nonatomic, copy)NSString *circleId;
@property (nonatomic, strong)HKMyPostModel *postM;
@property (nonatomic,weak) id<HKEditSharePostViewControllerDelegate> delegate;
@end
