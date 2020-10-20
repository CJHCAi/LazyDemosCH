//
//  MyCollectionViewCell.m
//  DragCollectionViewCellDemo
//
//  Created by 孙宁 on 16/4/5.
//  Copyright © 2016年 孙宁. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "Macro.h"

@implementation MyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (KScreenWidth - 2) / 3, (KScreenWidth - 2) / 3)];
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(((KScreenWidth - 2) / 3-50)/2, ((KScreenWidth - 2) / 3-50)/2, 50, 50)];
        [self.contentView addSubview:self.imageView];
        self.label=[[UILabel alloc] initWithFrame:CGRectMake(((KScreenWidth - 2) / 3-80)/2, ((KScreenWidth - 2) / 3-20)/2+50, 80, 20)];
        self.label.text=@"娱乐娱乐";
        [self.contentView addSubview:self.label];
        
    }
    return self;
}


@end
