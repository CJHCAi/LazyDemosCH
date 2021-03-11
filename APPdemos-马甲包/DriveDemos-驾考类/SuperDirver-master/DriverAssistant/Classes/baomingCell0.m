//
//  baomingCell0.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "baomingCell0.h"

@implementation baomingCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlabel];
        [self.contentView addSubview:self.baomingtext];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftlabel.frame = CGRectMake(20*WIDTH_SCALE, 10*HEIGHT_SCALE, 50*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.baomingtext.frame = CGRectMake(80*WIDTH_SCALE, 10*HEIGHT_SCALE, DEVICE_WIDTH-100*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters


-(UILabel *)leftlabel
{
    if(!_leftlabel)
    {
        _leftlabel = [[UILabel alloc] init];
        
    }
    return _leftlabel;
}


-(UITextField *)baomingtext
{
    if(!_baomingtext)
    {
        _baomingtext = [[UITextField alloc] init];
        
    }
    return _baomingtext;
}




@end
