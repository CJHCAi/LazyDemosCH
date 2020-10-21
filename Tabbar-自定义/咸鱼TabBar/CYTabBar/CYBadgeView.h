//
//  CYBadgeView.h
//  蚁巢
//
//  Created by 张春雨 on 2016/11/19.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYTabBarConfig.h"

@interface CYBadgeView : UIButton
/** remind number */
@property (copy , nonatomic) NSString *badgeValue;
/** remind color */
@property (copy , nonatomic) UIColor *badgeColor;
@end
