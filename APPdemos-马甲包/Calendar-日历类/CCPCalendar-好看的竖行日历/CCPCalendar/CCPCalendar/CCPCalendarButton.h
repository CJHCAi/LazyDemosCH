//
//  CCPCalendarButton.h
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPCalendarManager.h"
#import "NSDate+CCPCalendar.h"

@interface CCPCalendarButton : UIButton

@property (nonatomic, strong) CCPCalendarManager *manager;
//生成当前btn的date
@property (nonatomic, strong) NSDate *date;

- (void)ccpDispaly;
- (void)addObesers;
@end
