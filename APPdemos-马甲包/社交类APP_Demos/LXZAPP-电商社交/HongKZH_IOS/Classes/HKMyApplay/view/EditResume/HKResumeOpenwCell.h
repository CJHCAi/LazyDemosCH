//
//  HKResumeOpenwCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchValueChangedBlock)(BOOL changed);

@interface HKResumeOpenwCell : UITableViewCell

@property (nonatomic, assign, getter=isOpen) BOOL open;

@property (nonatomic, copy) SwitchValueChangedBlock block;

@end
