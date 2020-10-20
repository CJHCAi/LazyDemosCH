//
//  IgnoreHeaderTouchAndRecognizeSimultaneousTableView.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/9.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "IgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

@implementation IgnoreHeaderTouchAndRecognizeSimultaneousTableView

//可以响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
