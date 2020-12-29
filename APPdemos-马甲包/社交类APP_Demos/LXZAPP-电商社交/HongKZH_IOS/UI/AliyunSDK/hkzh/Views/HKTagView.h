//
//  HKTagView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTagView;
typedef void(^CancelBlock)(HKTagView *tagView);

@interface HKTagView : UIView

@property (nonatomic, strong) id tagValue;

@property (nonatomic, assign) NSInteger direction;  //1.往右边 0.往左边

@property (nonatomic, copy) CancelBlock cancelBlock;

- (void)remakeConstraintsWithDirection;

@end
