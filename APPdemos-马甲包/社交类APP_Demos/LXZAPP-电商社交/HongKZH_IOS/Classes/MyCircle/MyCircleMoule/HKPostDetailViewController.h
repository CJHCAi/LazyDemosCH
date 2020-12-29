//
//  HKPostDetailViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKMyPostsRespone.h"

typedef void(^deleteBlock)(void);

@interface HKPostDetailViewController : HKBaseViewController

@property (nonatomic, strong)HKMyPostModel * model;

@property (nonatomic, copy) NSString *postID;

@property (nonatomic, copy) deleteBlock block;

@end
