//
//  JRInfoView.h
//  JR
//
//  Created by Zj on 17/8/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRInfoView : UIView

/**
 显示图片
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 文本
 */
@property (nonatomic, strong) UILabel *label;

/**
 详细描述
 */
@property (nonatomic, strong) UILabel *detailLabel;

@end
