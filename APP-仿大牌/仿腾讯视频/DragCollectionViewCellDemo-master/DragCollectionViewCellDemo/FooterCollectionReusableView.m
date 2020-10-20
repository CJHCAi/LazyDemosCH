//
//  FooterCollectionReusableView.m
//  DragCollectionViewCellDemo
//
//  Created by 孙宁 on 16/4/5.
//  Copyright © 2016年 孙宁. All rights reserved.
//

#import "FooterCollectionReusableView.h"
#import "Macro.h"

@implementation FooterCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
        
    }
    return self;
}



@end
