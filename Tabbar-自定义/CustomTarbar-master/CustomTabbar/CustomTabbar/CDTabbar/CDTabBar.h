//
//  CDTabBar.h
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTabBar : UITabBar

@property (nonatomic,copy) void(^didMiddBtn)();
@end
