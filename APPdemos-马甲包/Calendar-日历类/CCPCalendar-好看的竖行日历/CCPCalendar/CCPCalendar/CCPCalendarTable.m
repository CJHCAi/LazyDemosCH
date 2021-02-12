//
//  CCPCalendarTable.m
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/28.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarTable.h"
#import "NSDate+CCPCalendar.h"
#import "CCPCalendarCellTableViewCell.h"
#import "UIView+CCPView.h"


@implementation CCPCalendarTable

- (instancetype)initWithFrame:(CGRect)frame manager:(CCPCalendarManager *)manager {
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.manager = manager;
        _exitViews = [NSMutableArray array];
        [self.dates enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_exitViews addObject:@""];
        }];
        [self registerClass:[CCPCalendarCellTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (self.manager.isShowPast) {
            NSInteger a = self.dates.count / 2;
            __block CGFloat y = 0;
            [self.dates enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < a) {
                    y += [self getHWithDate:obj];
                }
            }];
            [self setContentOffset:CGPointMake(0, y)];
        }
        if (self.manager.postionDate) {
            NSInteger month = [self.manager.postionDate getMonth];
            NSInteger year = [self.manager.postionDate getYear];
            __block CGFloat y = 0;
            [self.dates enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger obj_month = [obj getMonth];
                NSInteger obj_year = [obj getYear];
                if ((year - obj_year) >= 0 && (month - obj_month) > 0) {
                    y += [self getHWithDate:obj];
                }
            }];
            [self setContentOffset:CGPointMake(0, y)];
        }
        [self scrToCreate];
        self.bounces = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)scrToCreate {
    typeof(self)ws = self;
    self.manager.scrToCreateDate = ^() {
        if (ws.manager.isShowPast) {
            NSInteger a = ws.dates.count / 2;
            __block CGFloat y = 0;
            [ws.dates enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < a) {
                    y += [ws getHWithDate:obj];
                }
            }];
            [ws setContentOffset:CGPointMake(0, y) animated:YES];
        }
        else {
            [ws setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    };
   
}

- (NSArray<NSDate *> *)dates {
    if (!_dates) {
        NSDate *date = self.manager.createDate;
        NSMutableArray *mDates = [NSMutableArray array];
        if (!self.manager.isShowPast) {
            for (int i = 0; i < 13; i ++) {
                [mDates addObject:[date addMonth:i]];
            }
        }
        else {
            for (int i = -12; i < 13; i ++) {
                [mDates addObject:[date addMonth:i]];
            }
        }
        _dates = mDates.copy;
    }
    return _dates;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCPCalendarCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDate *date = self.dates[indexPath.row];
    if (!cell) {
        cell = [CCPCalendarCellTableViewCell new];
    }
    else {
        cell.manager = self.manager;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        if ([self.exitViews[indexPath.row] isKindOfClass:[UIView class]]) {
            [cell.contentView addSubview:self.exitViews[indexPath.row]];
        }
        else {
            UIView *av = [cell createDateView:date];
            [self.exitViews replaceObjectAtIndex:indexPath.row withObject:av];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.dates[indexPath.row];
    return [self getHWithDate:date];
}

- (CGFloat)getHWithDate:(NSDate *)date {
    NSInteger week = [date firstDay_week];
    NSInteger days = [date dayOfMonth];
    NSInteger week_last = [date lastDay_week];
    NSInteger count = week + days + 6 - week_last;
    NSInteger h = count / 7;
    if (count % 7 > 0) {
        h += 1;
    }
    return h * main_width / 7 + 49 * scale_h;
}


@end
