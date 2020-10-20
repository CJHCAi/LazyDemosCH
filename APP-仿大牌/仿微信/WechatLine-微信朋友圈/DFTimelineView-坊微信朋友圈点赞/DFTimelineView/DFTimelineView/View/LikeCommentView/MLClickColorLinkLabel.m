//
//  MLClickColorLinkLabel.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "MLClickColorLinkLabel.h"

@implementation MLClickColorLinkLabel



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor lightGrayColor];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [UIColor clearColor];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = [UIColor clearColor];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com