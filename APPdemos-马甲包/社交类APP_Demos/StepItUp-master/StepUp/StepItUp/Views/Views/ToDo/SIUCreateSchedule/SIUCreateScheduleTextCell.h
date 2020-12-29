//
//  SIUCreateScheduleTextCell.h
//  Step it up
//
//  Created by syfll on 15/4/3.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIUCreateScheduleTextCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentHeight;
@property (weak, nonatomic) IBOutlet UITextView *ReminderTextView;
@property (nonatomic, assign) BOOL isFirstEditing ;
+ (SIUCreateScheduleTextCell*) CreateCell;
@end
