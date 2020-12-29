//
//  HKResumeAddAllCellTableViewCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeBaseCell.h"

@interface HKResumeAddAllCell : HKUpdateResumeBaseCell

@property (nonatomic, strong) NSString *addTitle;

+ (instancetype)resumeAddCellWithTitle :(NSString *)title addCellBlock:(UpdateResumeBlock) block;

@end
