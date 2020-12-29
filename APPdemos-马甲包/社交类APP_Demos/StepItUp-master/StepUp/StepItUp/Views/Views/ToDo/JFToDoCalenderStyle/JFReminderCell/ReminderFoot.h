//
//  ReminderFoot.h
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFReminderAppearance.h"

@interface ReminderFoot : UITableViewCell
+ (ReminderFoot*) CreateCell;

@property (strong, nonatomic, readonly) JFReminderAppearance * reminderAppearance;
@property (weak, nonatomic) IBOutlet UIImageView *FootImageView;

@end
