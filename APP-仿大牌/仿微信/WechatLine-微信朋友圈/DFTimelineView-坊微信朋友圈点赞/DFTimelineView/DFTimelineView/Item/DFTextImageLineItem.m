//
//  DFTextImageLineItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineItem.h"

@implementation DFTextImageLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemType = LineItemTypeTextImage;
        
        _text = @"";
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
    }
    return self;
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com