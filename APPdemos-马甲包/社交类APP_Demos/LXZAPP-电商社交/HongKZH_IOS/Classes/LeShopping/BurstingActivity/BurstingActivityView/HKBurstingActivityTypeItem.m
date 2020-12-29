//
//  HKBurstingActivityTypeItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingActivityTypeItem.h"
@interface HKBurstingActivityTypeItem()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@end

@implementation HKBurstingActivityTypeItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKBurstingActivityTypeItem" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}
-(void)setModel:(LuckyBurstTypes *)model{
    _model = model;
    if (model.sortDate < 0) {
        self.timeBtn.selected = NO;
        NSString*beginTime ;
        if (model.beginDate>9) {
            beginTime = [NSString stringWithFormat:@"%ld:00",model.beginDate];
        }else{
            beginTime = [NSString stringWithFormat:@"0%ld:00",model.beginDate];
        }
        [self.timeBtn setTitle:beginTime forState:0];
        self.typeLabel.text = @"已结束";
        self.typeLabel.textColor = [UIColor colorFromHexString:@"EF593C"];
        self.backIcon.image =nil;
    }else if(model.sortDate==0){
        self.timeBtn.selected = YES;
        NSString*beginTime ;
        NSString*endTime;
        if (model.beginDate>9) {
            beginTime = [NSString stringWithFormat:@"%ld:00",model.beginDate];
        }else{
            beginTime = [NSString stringWithFormat:@"0%ld:00",model.beginDate];
        }
        if (model.endDate>9) {
            endTime = [NSString stringWithFormat:@"%ld:00",model.endDate];
        }else{
            endTime = [NSString stringWithFormat:@"0%ld:00",model.endDate];
        }
       NSString*time = [NSString stringWithFormat:@"%@-%@",beginTime,endTime];
        [self.timeBtn setTitle:time forState:0];
        self.typeLabel.text = @"抢购中";
        self.typeLabel.textColor = [UIColor whiteColor];
        self.backIcon.image = [UIImage imageNamed:@"bkms_qgz"];
    }else{
        self.timeBtn.selected = NO;
        NSString*beginTime ;
        if (model.beginDate>9) {
            beginTime = [NSString stringWithFormat:@"%ld:00",model.beginDate];
        }else{
            beginTime = [NSString stringWithFormat:@"0%ld:00",model.beginDate];
        }
        [self.timeBtn setTitle:beginTime forState:0];
        self.typeLabel.text = @"即将开始";
        self.typeLabel.textColor = [UIColor colorFromHexString:@"333333"];
        self.backIcon.image = nil;
    }
}
- (IBAction)clickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self.tag];
    }
}
@end
