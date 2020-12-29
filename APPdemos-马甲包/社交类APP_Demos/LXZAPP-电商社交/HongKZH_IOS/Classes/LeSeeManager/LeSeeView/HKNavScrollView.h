//
//  HKNavScrollView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectCategory)(int index);
@interface HKNavScrollView : UIView
@property (nonatomic, strong)NSMutableArray *navArray;
@property (nonatomic, copy)SelectCategory selectCategory;

@property (nonatomic,assign) NSInteger item;
@end
