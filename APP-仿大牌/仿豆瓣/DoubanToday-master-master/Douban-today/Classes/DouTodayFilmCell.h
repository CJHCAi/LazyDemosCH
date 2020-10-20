//
//  DouTodayFilmCell.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DouTodayFilmCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bgimageView;         // 图片
@property (strong, nonatomic) UIView *bgView;                   // 背景
@property (strong, nonatomic) UILabel *titleLabel;              // 主标题
@property (strong, nonatomic) UILabel *contentLabel;            // 副标题

@end
