//
//  DFBaseLineItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@implementation DFBaseLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _likes = [NSMutableArray array];
        _comments = [NSMutableArray array];
        
        _commentStrArray = [NSMutableArray array];
    }
    return self;
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com