//
//  CheckinCell.h
//  DataBaseText
//
//  Created by 劳景醒 on 16/12/14.
//  Copyright © 2016年 laojingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckinModel.h"
@interface CheckinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulerLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightCodeLabel;


@property (nonatomic, strong) CheckinModel *model;
@end
