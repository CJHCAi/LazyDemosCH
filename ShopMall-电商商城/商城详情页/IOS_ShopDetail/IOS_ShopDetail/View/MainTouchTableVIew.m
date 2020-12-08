//
//  MainTouchTableVIew.m
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/6/28.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import "MainTouchTableVIew.h"

@implementation MainTouchTableVIew
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
