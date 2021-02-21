//
//  YCBaseNavigationController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/28.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseNavigationController.h"

@interface YCBaseNavigationController ()

@end
@implementation YCBaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:YC_Nav_TitleColor, NSFontAttributeName:YC_Nav_TitleFont}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"yc_nav_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]  forBarMetrics:UIBarMetricsDefault];
    UIImageView *lineView = [self findHairlineImageViewUnder:self.navigationBar];
    UIView *diyLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 0.5)];
    diyLine.backgroundColor = YC_Base_LineColor;
    [lineView addSubview:diyLine];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
