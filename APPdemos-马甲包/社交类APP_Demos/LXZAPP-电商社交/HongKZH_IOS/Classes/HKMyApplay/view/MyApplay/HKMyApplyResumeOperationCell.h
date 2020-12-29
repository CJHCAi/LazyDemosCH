//
//  HKMyApplyResumeOperationCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResumeOperationBlock)(NSInteger index);

@interface HKMyApplyResumeOperationCell : UITableViewCell

@property (nonatomic, copy) ResumeOperationBlock block;

@end
