//
//  HKLineView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLineView.h"
#import "UIView+BorderLine.h"
@implementation HKLineView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self borderForColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
       [self borderForColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
