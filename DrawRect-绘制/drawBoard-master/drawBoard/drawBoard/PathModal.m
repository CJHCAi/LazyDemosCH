//
//  PathModal.m
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "PathModal.h"

@implementation PathModal

- (void)dealloc{
    CGPathRelease(_path);
    
}

- (void)setPath:(CGPathRef)path {
    if (_path != path) {
        _path = CGPathRetain(path);
    }
}
@end
