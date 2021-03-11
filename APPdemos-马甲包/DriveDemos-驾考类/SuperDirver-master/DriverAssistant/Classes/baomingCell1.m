//
//  baomingCell1.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "baomingCell1.h"

@implementation baomingCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.settext];
        [self.contentView addSubview:self.setbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.settext.frame = CGRectMake(20*WIDTH_SCALE, 10*HEIGHT_SCALE, 120*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.setbtn.frame = CGRectMake(DEVICE_WIDTH-140*WIDTH_SCALE, 10*HEIGHT_SCALE, 120*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters

-(UITextField *)settext
{
    if(!_settext)
    {
        _settext = [[UITextField alloc] init];
        _settext.placeholder = @"请输入验证码";
    }
    return _settext;
}

-(UIButton *)setbtn
{
    if(!_setbtn)
    {
        _setbtn = [[UIButton alloc] init];
       // _setbtn.backgroundColor = [UIColor redColor];
    }
    return _setbtn;
}



@end
