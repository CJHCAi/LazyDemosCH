//
//  YXWWPCollectionViewCell.h
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseCollectionViewCell.h"

@interface YXWWPCollectionViewCell : YXWBaseCollectionViewCell

@property (nonatomic, strong) UIImageView *wallPaperImageView;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIView *wallPaperView;
@property (nonatomic, strong) UILabel *wallLabel;
@property (nonatomic, strong) UIImageView *smallWPImageView;

@end
