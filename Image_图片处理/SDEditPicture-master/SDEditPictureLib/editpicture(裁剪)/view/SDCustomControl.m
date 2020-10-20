//
//  SDCustomControl.m
//  NestHouse
//
//  Created by shansander on 2017/5/12.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDCustomControl.h"

@implementation SDCustomControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (id target in [self allTargets]) {
        NSArray * actions = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString * action in actions) {
            [self sendAction:NSSelectorFromString(action) to:target forEvent:event];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
