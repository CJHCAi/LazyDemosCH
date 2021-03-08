//
//  jiaolianCell.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "jiaolianCell.h"

@implementation jiaolianCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftimg];
        [self.contentView addSubview:self.messagelab];
        [self.contentView addSubview:self.namelab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftimg.frame = CGRectMake(20*WIDTH_SCALE, 20*HEIGHT_SCALE, 80*WIDTH_SCALE, 80*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(130*WIDTH_SCALE, 20*HEIGHT_SCALE, 100*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.messagelab.frame = CGRectMake(130*WIDTH_SCALE, self.frame.size.height/2, DEVICE_WIDTH-150, 25*HEIGHT_SCALE);
}


-(UIImageView *)leftimg
{
    if(!_leftimg)
    {
        _leftimg = [[UIImageView alloc] init];
        _leftimg.layer.masksToBounds = YES;
        _leftimg.layer.cornerRadius = 40*WIDTH_SCALE;
        
    }
    return _leftimg;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"008CCF"];
    }
    return _namelab;
}

-(UILabel *)messagelab
{
    if(!_messagelab)
    {
        _messagelab = [[UILabel alloc] init];
        
    }
    return _messagelab;
}





@end
