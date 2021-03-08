//
//  logupCell2.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/20.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "logupCell2.h"

@implementation logupCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.loguptext];
        [self.contentView addSubview:self.yanzhengmabtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.loguptext.frame = CGRectMake(20*WIDTH_SCALE, 10*HEIGHT_SCALE, 120*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.yanzhengmabtn.frame = CGRectMake(DEVICE_WIDTH-120*WIDTH_SCALE, 10*HEIGHT_SCALE, 120*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters

-(UITextField *)loguptext
{
    if(!_loguptext)
    {
        _loguptext = [[UITextField alloc] init];
        
    }
    return _loguptext;
}

-(UIButton *)yanzhengmabtn
{
    if(!_yanzhengmabtn)
    {
        _yanzhengmabtn = [[UIButton alloc] init];
        [_yanzhengmabtn setTitleColor:[UIColor blackColor] forState:normal];
        [_yanzhengmabtn setTitle:@"获取验证码" forState:normal];
    }
    return _yanzhengmabtn;
}



@end
