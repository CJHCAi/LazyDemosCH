//
//  logupCell.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/20.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "logupCell.h"

@implementation logupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.logtext];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftlab.frame = CGRectMake(20*WIDTH_SCALE, 10*HEIGHT_SCALE, 80*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.logtext.frame = CGRectMake(110*WIDTH_SCALE, 10*HEIGHT_SCALE, DEVICE_WIDTH-120*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters


-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        
    }
    return _leftlab;
}

-(UITextField *)logtext
{
    if(!_logtext)
    {
        _logtext = [[UITextField alloc] init];
        
    }
    return _logtext;
}



@end
