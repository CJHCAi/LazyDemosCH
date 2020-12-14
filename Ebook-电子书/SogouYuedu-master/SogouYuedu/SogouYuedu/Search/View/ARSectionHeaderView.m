//
//  ARSectionHeaderView.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARSectionHeaderView.h"

@implementation ARSectionHeaderView


+ (void)addHeaderToView:(UIView *)superView{
    // create the button object
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = RGB(242, 242, 242);
    headerLabel.textColor = RGB(126, 127, 126);
    headerLabel.highlightedTextColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(0, 0 , ARScreenWidth, 25);
    headerLabel.text = @"     以下内容来自互联网";
    [superView addSubview:headerLabel];
}

@end
