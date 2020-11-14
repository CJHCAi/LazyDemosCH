//
//  NormalCell.m
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import "NormalCell.h"

@implementation NormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCategory:(NSString *)category{
    _category = category;
    
    self.lab1.text = category;
    
}

- (void)setInfo:(InfoModel *)info{
    
    _info = info;
    
    if ([self.category isEqualToString:@"性别"]) {
        self.lab2.text = info.sex;
    }
//     self.categoryAry = @[@"性别",@"",@"体重",@"出生年月",@"时间",@"区间",@"省市"
    
    if ([self.category isEqualToString:@"身高"]) {
        self.lab2.text = info.heigh;
    }
    
    if ([self.category isEqualToString:@"体重"]) {
        self.lab2.text = info.weight;
    }
    
    if ([self.category isEqualToString:@"出生年月"]) {
        self.lab2.text = info.birthday;
    }
    
    
    if ([self.category isEqualToString:@"时间"]) {
        self.lab2.text = info.time;
    }
    
    if ([self.category isEqualToString:@"区间"]) {
        self.lab2.text = info.rang;
    }
    
    if ([self.category isEqualToString:@"省市"]) {
        self.lab2.text = info.city;
    }
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
