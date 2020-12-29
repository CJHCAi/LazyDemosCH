//
//  PathModal.m
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "PathModal.h"

@implementation PathModal

- (void)dealloc {
    CGPathRelease(_path);
}

- (void)setPath:(CGMutablePathRef)path {
    if (_path != path) {
        _path = (CGMutablePathRef)CGPathRetain(path);
        
    }
}


@end
