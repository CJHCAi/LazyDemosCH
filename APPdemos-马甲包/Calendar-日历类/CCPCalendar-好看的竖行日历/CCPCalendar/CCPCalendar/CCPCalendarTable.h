//
//  CCPCalendarTable.h
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/28.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPCalendarManager.h"

@interface CCPCalendarTable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CCPCalendarManager *manager;
@property (nonatomic, strong) NSArray<NSDate *>* dates;
@property (nonatomic, strong) NSMutableArray *exitViews;
- (instancetype)initWithFrame:(CGRect)frame manager:(CCPCalendarManager *)manager;
@end
