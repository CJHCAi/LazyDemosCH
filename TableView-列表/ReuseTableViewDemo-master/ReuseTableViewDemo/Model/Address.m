//
//  Address.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "Address.h"

static const CGFloat buttonHeight = 25;

@implementation Address

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (CGFloat)cellHeight {
    
    NSInteger c = self.USERS.count/4;
    NSInteger l = self.USERS.count%4;
    CGFloat userButtonsViewHeight = 0;
    if (l != 0) {
        userButtonsViewHeight = (c + 1)*(buttonHeight + 10);
    } else {
        userButtonsViewHeight = c*(buttonHeight + 10);
    }
    CGFloat contentHeight = 13 + 13 + 8 + userButtonsViewHeight + 18;
    return contentHeight;
}

@end
