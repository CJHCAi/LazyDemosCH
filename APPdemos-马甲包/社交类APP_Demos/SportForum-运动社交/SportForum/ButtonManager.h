//
//  ButtonManager.h
//  housefinder
//
//  Created by zyshi on 13-7-24.
//  Copyright (c) 2013年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonManager : NSObject

- (void)registerButton:(UIButton *)button;
- (void)showRegisterButton:(BOOL)bShow;

@end
