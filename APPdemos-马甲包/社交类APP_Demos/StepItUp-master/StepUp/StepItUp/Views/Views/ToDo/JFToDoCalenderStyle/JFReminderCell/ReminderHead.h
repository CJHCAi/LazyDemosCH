//
//  ReminderHead.h
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFReminderAppearance.h"
@interface ReminderHead : UITableViewCell

+ (ReminderHead*) CreateCell;
@property (weak, nonatomic) IBOutlet UIImageView *headCircleImageView;
@property (strong, nonatomic, readonly) JFReminderAppearance * reminderAppearance;
@end
