//
//  YTLeftslideCell.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/10.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTLeftslideCell.h"

@implementation YTLeftslideCell

-(void)layoutSubviews{

    [super layoutSubviews];

    self.textLabel.font = [UIFont systemFontOfSize:13.0];
    self.detailTextLabel.font = [UIFont systemFontOfSize:9.0];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor grayColor];

    self.backgroundColor = [UIColor clearColor];
}




@end
