//
//  ZJCycleViewCell.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/9.
//  Copyright © 2018年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCycleViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleL;

@property (strong, nonatomic) UILabel *currentPageL;

@property (nonatomic, strong) UIView *titleBackgroundView;

@end
