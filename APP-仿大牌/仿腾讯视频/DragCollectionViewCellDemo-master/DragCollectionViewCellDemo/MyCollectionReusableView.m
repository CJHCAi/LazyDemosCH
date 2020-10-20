
//
//  MyCollectionReusableView.m
//  DragCollectionViewCellDemo
//
//  Created by 孙宁 on 16/4/5.
//  Copyright © 2016年 孙宁. All rights reserved.
//

#import "MyCollectionReusableView.h"
#import "Macro.h"

@implementation MyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.alpha=0.7;
        [self addSubview:self.label];
    }
    return self;
}


@end
