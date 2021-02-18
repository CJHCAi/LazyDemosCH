//
//  GeoTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/5.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "GeoTableViewCell.h"

@implementation GeoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.customLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
        self.customLB.font = MFont(13);
        self.customLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.customLB];
    }
    return self;
}



@end
