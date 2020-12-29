//
//  HKChooseChannelTableViewCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
    企业招聘,顶部 cell
 */
#import "HKInitializationRespone.h"
typedef void(^ControlClickBlock)(void);

@interface HKChooseChannelTableViewCell : UITableViewCell

@property (nonatomic, strong) HK_BaseAllCategorys *category;

@property (nonatomic, copy) AllmediacategorysModel * mediaModel;

@property (nonatomic, copy) ControlClickBlock block;
@property (nonatomic, assign)BOOL istrvel;
@end
