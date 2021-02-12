//
//  LTSCalendarSelectedWeekView.m
//  scrollTest
//
//  Created by leetangsong_macbk on 16/6/1.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import "LTSCalendarSelectedWeekView.h"
#import "LTSCalendarManager.h"
#define NUMBER_PAGES_LOADED 5


@implementation LTSCalendarSelectedWeekView{
    UIView *line;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        line = [UIView new];
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(1);
//        }];
        line.backgroundColor = lineBGColor;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews{
   
     self.contentSize = CGSizeMake(self.frame.size.width*NUMBER_PAGES_LOADED, self.frame.size.height);
     [super layoutSubviews];
    
    
    
}
@end
