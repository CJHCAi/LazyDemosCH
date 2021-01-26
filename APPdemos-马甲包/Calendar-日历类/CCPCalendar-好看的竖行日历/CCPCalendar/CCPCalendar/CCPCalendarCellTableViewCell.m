//
//  CCPCalendarCellTableViewCell.m
//  CCPCalendar
//
//  Created by 储诚鹏 on 17/5/28.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarCellTableViewCell.h"
#import "CCPCalendarManager.h"
#import "CCPCalendarButton.h"
#import "UIView+CCPView.h"

@implementation CCPCalendarCellTableViewCell


/*
 * 生成一个月的日历
 */
- (UIView *)createDateView:(NSDate *)date {
    UIView *dateSupV = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    CGFloat t_gap = 15 * scale_h;
    CGFloat l_gap = 25 * scale_w;
    CGFloat label_h = 24 * scale_h;
    UILabel *bigLabel = [[UILabel alloc] init];
    [bigLabel setFont:[UIFont boldSystemFontOfSize:bigLabel.font.pointSize]];
    NSString *label_text;
    
    NSString *month = [NSString stringWithFormat:@"%02ld",(long)[date getMonth]];
    
    if ([date getYear]==[self.manager.createDate getYear]) {
        month = [NSString stringWithFormat:@"%@月",month];
        label_text = month;
    }
    else {
        label_text = [NSString stringWithFormat:@"%ld年%@",(long)[date getYear],month];
    }
    bigLabel.text = label_text;
    bigLabel.backgroundColor = [UIColor clearColor];
    CGFloat label_w = [bigLabel widthBy:label_h];
    bigLabel.frame = CGRectMake(l_gap, t_gap, label_w, label_h);
    bigLabel.textColor = [UIColor whiteColor];
    [dateSupV addSubview:bigLabel];
    NSInteger week = [date firstDay_week];
    NSInteger week_last = [date lastDay_week];
    NSInteger days = [date dayOfMonth];
    CGFloat w = main_width / 7;
    NSInteger count = week + days + 6 - week_last;
    for (int i = 0; i < count; i++) {
        NSInteger row = i / 7;
        NSInteger column = i - row * 7;
        CCPCalendarButton *btn = [[CCPCalendarButton alloc] initWithFrame:CGRectMake(column * w, row * w + CGRectGetMaxY(bigLabel.frame) + 10 * scale_h, w, w)];
        NSString *ym = [NSString stringWithFormat:@"%ld%02ld%02d",[date getYear],[date getMonth],i];
        btn.tag = [ym integerValue];
        btn.date = [date changToDay:i - week + 1];
        btn.manager = self.manager;
        btn.enabled = NO;
        if (i >= week && i < (count + week_last - 6)) {
            NSString * titleNum = [NSString stringWithFormat:@"%ld",i - week + 1];
            btn.enabled = YES;
            [self manageClick];
            [btn ccpDispaly];
            [btn setTitle:titleNum forState:UIControlStateNormal];
        }
        [btn addObesers];
        [dateSupV addSubview:btn];
//        btn.selected = NO;
//        [self.manager.selectArr enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([btn.date isSameTo:obj]) {
//                btn.selected = YES;
//                *stop = YES;
//            }
//        }];
    }
    dateSupV.backgroundColor = [UIColor clearColor];
    [self managerClean];
    CGFloat h = [dateSupV getSupH];
    dateSupV.frame = CGRectMake(0, 0, main_width, h);
    [self.contentView addSubview:dateSupV];
    return dateSupV;
}

//清除
- (void)managerClean {
    __weak typeof(self)ws = self;
    self.manager.clean = ^() {
        ws.manager.startTitle = ws.manager.endTitle = nil;
        ws.manager.startTag = ws.manager.endTag = 0;
        for (CCPCalendarButton *btn in ws.manager.selectBtns) {
            btn.manager = ws.manager;
            btn.selected = NO;
        }
        [ws.manager.selectBtns removeAllObjects];
    };
}



//按钮点击
- (void)manageClick {
    __weak typeof(self)ws = self;
    self.manager.click = ^(UIButton *abtn) {
        if (ws.manager.selectType == 0) {
            if (ws.manager.selectBtns.count > 0) {
                UIButton *lastBtn = ws.manager.selectBtns.firstObject;
                if (abtn == lastBtn) {
                    return;
                }
                lastBtn.selected = NO;
                [ws.manager.selectBtns removeAllObjects];
            }
        }
        else if (ws.manager.selectType == 1) {
            if (ws.manager.selectBtns.count > 1) {
                for (UIButton *lastBtn in ws.manager.selectBtns) {
                    lastBtn.selected = NO;
                }
                [ws.manager.selectBtns removeAllObjects];
                ws.manager.endTag = ws.manager.startTag = 0;
            }
            else if (ws.manager.selectBtns.count > 0) {
                UIButton *lastBtn = ws.manager.selectBtns.firstObject;
                CCPCalendarButton *ccpBtn1 = (CCPCalendarButton *)lastBtn;
                CCPCalendarButton *ccpBtn2 = (CCPCalendarButton *)abtn;
                if (ccpBtn1 == ccpBtn2) {
                    return;
                }
                if (![ccpBtn1.date earlyThan:ccpBtn2.date]) {
                    ccpBtn1.selected = NO;
                    [ws.manager.selectBtns removeObject:ccpBtn1];
                }
                else {
                    ws.manager.startTag = ccpBtn1.tag;
                    ws.manager.endTag = ccpBtn2.tag;
                }
            }
        }
        [ws.manager.selectArr removeAllObjects];
        [ws.manager.selectBtns addObject:abtn];
        for (CCPCalendarButton *obj in ws.manager.selectBtns) {
            [[ws.manager mutableArrayValueForKey:@"selectArr"] addObject:obj.date];
        }
    };
}



@end
