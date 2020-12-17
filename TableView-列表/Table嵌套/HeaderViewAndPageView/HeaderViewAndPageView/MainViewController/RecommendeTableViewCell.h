//
//  RecommendeTableViewCell.h
//  HeaderViewAndPageView
//
//  Created by yangpan on 2016/12/19.
//  Copyright © 2016年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *sold;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
