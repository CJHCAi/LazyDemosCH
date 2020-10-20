//
//  JRGymClassCell.h
//  JR
//
//  Created by Zj on 17/8/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRGymClassCell : UITableViewCell

/**
 课程图片
 */
@property (nonatomic, strong) UIImageView *classImageView;

/**
 课程描述
 */
@property (nonatomic, strong) UILabel *classInfoLabel;

/**
 课程时间描述
 */
@property (nonatomic, strong) UILabel *classTimeLabel;

/**
 人数
 */
@property (nonatomic, strong) UILabel *memberLabel;

/**
 参与
 */
@property (nonatomic, strong) UIButton *joinBtn;

@end
