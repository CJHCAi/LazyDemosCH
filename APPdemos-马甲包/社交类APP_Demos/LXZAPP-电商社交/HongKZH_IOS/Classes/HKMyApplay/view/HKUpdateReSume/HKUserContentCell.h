//
//  HKUserContentCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeBaseCell.h"

@interface HKUserContentCell : HKUpdateResumeBaseCell

@property (nonatomic, strong) NSString *userContent;

+ (instancetype)cellWithUserContent:(NSString *)userContent cellBlock:(UpdateResumeBlock) block;

@end
