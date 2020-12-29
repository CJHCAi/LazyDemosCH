//
//  XFZ_AddAlarm_TableViewCell.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/12.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "XFZ_AddAlarm_TableViewCell.h"

@implementation XFZ_AddAlarm_TableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.yyy = [[UIView alloc] initWithFrame:CGRectZero];
        _yyy.backgroundColor = [UIColor colorWithWhite:0.200 alpha:0.700];
        [self.contentView addSubview:_yyy];
        
        
        self.xingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.xingLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.xingLabel];
        
        self.timeLebel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLebel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeLebel];
        
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.dayLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.dayLabel];
        
        self.haoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.haoLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.haoLabel];

        self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.customImageView setImage:[UIImage imageNamed:@"tiaowu"]];
        
        [self.contentView addSubview:self.customImageView];
    }
    return self;
}

- (void)setDataModel:(ZFZ_dataModel *)dataModel {
    _dataModel = dataModel;
    
    
    NSString *str = @"周六"@"周七";
    NSString *str1 = @"周一"@"周二"@"周三"@"周四"@"周五"@"周六"@"周日";
    NSString *str2 = @"周一"@"周二"@"周三"@"周四"@"周五";
    if ([dataModel.week isEqualToString:str]) {
        self.xingLabel.text = @"周末";
    } else if ([dataModel.week isEqualToString:str1]) {
        self.xingLabel.text = @"每天";
    } else if ([dataModel.week isEqualToString:str2]) {
        self.xingLabel.text = @"工作日";
    } else {
        self.xingLabel.text = self.dataModel.week;
    }
    self.timeLebel.text = dataModel.hour;
    self.dayLabel.text = dataModel.minute;
    self.haoLabel.text = @":";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.yyy.frame = CGRectMake(40, 5, self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height - 20);
    //添加圆角
    self.yyy.layer.cornerRadius = 20;
    self.yyy.layer.masksToBounds = YES;
    
    self.yyy.layer.borderWidth = 1;
    
    self.yyy.layer.borderColor = [[UIColor whiteColor] CGColor];
    


    self.xingLabel.frame = CGRectMake(self.contentView.bounds.size.width * 0.1, 25, self.contentView.bounds.size.width, 20);
    self.xingLabel.font = [UIFont systemFontOfSize:13];
    
    self.timeLebel.frame = CGRectMake(self.contentView.bounds.size.width * 0.1, 10, 25, 20);
    self.dayLabel.frame = CGRectMake(self.contentView.bounds.size.width * 0.15, 10, 25, 20);
    self.haoLabel.frame = CGRectMake(self.contentView.bounds.size.width * 0.14, 9, 25, 20);
    
    self.customImageView.frame = CGRectMake(self.contentView.bounds.size.width * 0.5, 13, 25, 20);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
