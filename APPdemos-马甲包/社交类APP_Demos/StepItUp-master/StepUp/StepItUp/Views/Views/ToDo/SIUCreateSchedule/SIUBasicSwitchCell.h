//
//  SIUBasicSwitchCell.h
//  Step it up
//
//  Created by syfll on 15/4/4.
//  Copyright (c) 2015年 syfll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIUBasicSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *SSwitch;
+(SIUBasicSwitchCell*) CreateCell;
@end
