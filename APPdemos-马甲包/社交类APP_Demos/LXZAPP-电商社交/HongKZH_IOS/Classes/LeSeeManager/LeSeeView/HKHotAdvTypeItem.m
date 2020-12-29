//
//  HKHotAdvTypeItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHotAdvTypeItem.h"
@interface HKHotAdvTypeItem()
@property (weak, nonatomic) IBOutlet UILabel *starTIme;
@property (weak, nonatomic) IBOutlet UILabel *staueLabel;

@end

@implementation HKHotAdvTypeItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKHotAdvTypeItem" owner:self options:nil].lastObject;
    }
    return self;
}
-(void)setModel:(EnterpriseHotAdvTypeListModel *)model{
    _model = model;
    self.starTIme.text = model.subtitle;
    if (model.sortDate >= 0) {
        self.staueLabel.text = @"开抢中";
    }else{
        self.staueLabel.text = @"即将开始";
    }
}
- (IBAction)itemClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickWithTag:)]) {
        [self.delegate clickWithTag:self.tag];
    }
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (_isSelect) {
        self.starTIme.font = [UIFont boldSystemFontOfSize:20];
        self.starTIme.textColor = [UIColor colorFromHexString:@"333333"];
    }else{
        self.starTIme.font = PingFangSCMedium15;
        self.starTIme.textColor = [UIColor colorFromHexString:@"666666"];
    }
    
}
@end
