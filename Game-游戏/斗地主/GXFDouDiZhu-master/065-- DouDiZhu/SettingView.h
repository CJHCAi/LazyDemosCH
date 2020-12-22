//
//  SettingView.h
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/23.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingView;
@protocol SettingViewDelegate <NSObject>

- (void)settingView:(SettingView *)settingView didClickBackButton:(UIButton *)backButton;

@end

@interface SettingView : UIImageView

@property (nonatomic, weak) id<SettingViewDelegate> delegate;

- (void)backButtonClcik;

@end
