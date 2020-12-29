//
//  HKUpdateResumeBaseCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateResumeBlock)(void);

@interface HKUpdateResumeBaseCell : UITableViewCell

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, copy) UpdateResumeBlock updateResumeBlock;

@end
