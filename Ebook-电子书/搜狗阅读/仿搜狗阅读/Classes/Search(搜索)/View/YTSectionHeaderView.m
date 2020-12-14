//
//  YTSectionHeaderView.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/5.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTSectionHeaderView.h"

@implementation YTSectionHeaderView

+ (void)addHeaderToView:(UIView *)superView{
    // create the button object
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = RGB(242, 242, 242);
    headerLabel.textColor = RGB(126, 127, 126);
    headerLabel.highlightedTextColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(0, 0 , YTScreenWidth, 25);
    headerLabel.text = @"     以下内容来自互联网";
    [superView addSubview:headerLabel];
}





@end
