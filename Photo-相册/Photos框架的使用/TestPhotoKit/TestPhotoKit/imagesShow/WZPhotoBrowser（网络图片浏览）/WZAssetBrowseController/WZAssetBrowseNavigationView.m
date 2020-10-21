//
//  WZAssetBrowseNavigationView.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseNavigationView.h"

@implementation WZAssetBrowseNavigationView

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocolAssetBrowseNaviagtion>)delegate {
    WZAssetBrowseNavigationView *navigation = [[WZAssetBrowseNavigationView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 64.0)];
    navigation.delegate = delegate;
    navigation.backgroundColor = [UIColor colorWithRed:51.0 / 255  green:51.0 / 255 blue:51.0 / 255 alpha:0.4];
    
    CGFloat buttonHW = 44.0;
    navigation.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20.0, buttonHW, buttonHW)];
    navigation.selectedButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - buttonHW, 20.0, buttonHW, buttonHW)];
    navigation.titleLabel.textAlignment = NSTextAlignmentCenter;
    navigation.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonHW, 20.0, [UIScreen mainScreen].bounds.size.width - buttonHW * 2.0, buttonHW)];
    navigation.titleLabel.textAlignment = NSTextAlignmentCenter;
    navigation.titleLabel.textColor = [UIColor whiteColor];
    
    [navigation addSubview:navigation.titleLabel];
    [navigation addSubview:navigation.selectedButton];
    [navigation addSubview:navigation.backButton];
    
    [navigation.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigation.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [navigation.backButton setImage:[UIImage imageNamed:@"imagesBrowse_back"] forState:UIControlStateNormal];
    [navigation.selectedButton setImage:[UIImage imageNamed:@"message_oeuvre_btn_normal"] forState:UIControlStateNormal];
    [navigation.selectedButton setImage:[UIImage imageNamed:@"message_oeuvre_btn_selected"] forState:UIControlStateSelected];
    
    navigation.titleLabel.text = @"图片";
    [navigation.selectedButton addTarget:navigation action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigation.backButton addTarget:navigation action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return navigation;
}

- (void)clickedBtn:(UIButton *)sender {
    if (sender == self.backButton) {
        if ([_delegate respondsToSelector:@selector(backAction)]) {
            [_delegate backAction];
        }
    } else if (sender == self.selectedButton) {
        if ([_delegate respondsToSelector:@selector(selectedAction)]) {
            [_delegate selectedAction];
        }
    }
}

@end
