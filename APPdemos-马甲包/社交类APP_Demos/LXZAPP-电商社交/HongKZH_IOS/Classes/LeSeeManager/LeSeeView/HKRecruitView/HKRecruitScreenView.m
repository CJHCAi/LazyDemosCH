//
//  HKRecruitScreenView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecruitScreenView.h"

@interface HKRecruitScreenView()<HKTitleAndImageBtnDelegate>

@end

@implementation HKRecruitScreenView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKRecruitScreenView" owner:self options:nil].lastObject;
          [self.btn1 setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] title:@"职位类别" imageName:@"recruit_down"];
            [self.btn2 setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] title:@"地点" imageName:@"recruit_down"];
            [self.btn3 setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] title:@"薪水(元)" imageName:@"recruit_down"];
            [self.btn4 setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1] title:@"高级筛选" imageName:@"recruit_down"];
        self.btn1.tag = 0;
        self.btn1.delegate = self;
        self.btn2.tag = 1;
        self.btn2.delegate = self;
        self.btn3.tag = 2;
        self.btn3.delegate = self;
        self.btn4.tag = 3;
        self.btn4.delegate = self;
    }
    return self;
}
-(void)btnClick:(HKTitleAndImageBtn *)sender{
    if ([self.delegate respondsToSelector:@selector(goToClick:)]) {
        [self.delegate goToClick:sender.tag];
    }
}
@end
