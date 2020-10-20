//
//  singleSelectTableViewCell.h
//  singleSelectedDemo
//
//  Created by qhx on 2017/7/27.
//  Copyright © 2017年 quhengxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singleSelectTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);
@end
