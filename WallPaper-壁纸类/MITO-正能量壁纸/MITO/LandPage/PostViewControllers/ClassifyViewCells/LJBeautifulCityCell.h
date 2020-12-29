//
//  LJBeautifulCityCell.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/27.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBeautifulCityModel.h"

@interface LJBeautifulCityCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) LJBeautifulCityModel *model;

@end
