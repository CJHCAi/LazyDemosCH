//
//  ReminderCell.h
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFReminderAppearance.h"
@interface ReminderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderContentLabel;
@property (strong, nonatomic, readonly) JFReminderAppearance * reminderAppearance;

+ (ReminderCell*) CreateCell;
@end
