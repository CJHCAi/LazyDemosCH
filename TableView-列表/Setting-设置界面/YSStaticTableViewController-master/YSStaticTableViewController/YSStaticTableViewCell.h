//
//  YSStaticTableViewCell.h
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//
//  所有自定义Cell的基类 YSStaticTableViewCell

#import <UIKit/UIKit.h>
#import "YSStaticCellModel.h"

@interface YSStaticTableViewCell : UITableViewCell

@property (nonatomic, strong) YSStaticCellModel *cellModel;

/// 布局cel
- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel;

@end

@interface YSStaticDefaultCell : YSStaticTableViewCell



@end

@interface YSStaticButtonCell : YSStaticTableViewCell



@end

