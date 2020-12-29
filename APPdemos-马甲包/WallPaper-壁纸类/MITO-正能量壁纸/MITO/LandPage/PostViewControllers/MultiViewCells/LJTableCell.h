//
//  LJTableCell.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/31.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LJTableViewModel.h"

@interface LJTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage1;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage2;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage3;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (nonatomic, strong) LJTableViewModel *model;

@end
