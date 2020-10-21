//
//  ZJPhoto.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJPhoto.h"

@implementation ZJPhoto


-(CGFloat)maxZoomScale {

    if (_maxZoomScale == 0) {
        
        return 3.0;
    }

    return _maxZoomScale;
}

- (CGFloat)minZoomScale {

    if (_minZoomScale == 0) {
        
        return 1.0;
    }
    return _minZoomScale;
}

@end
