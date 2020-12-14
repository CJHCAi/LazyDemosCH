//
//  GTCommontHeader.h
//  iphone6 Fix Demo
//
//  Created by GuanTian Li on 14-11-5.
//  Copyright (c) 2014年 GCI. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef iphone6_Fix_Demo_GTCommontHeader_h
#define iphone6_Fix_Demo_GTCommontHeader_h

CG_INLINE CGFloat GTFixHeightFloat(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    height = height*mainFrme.size.height/1096*2;
    return height;
}

CG_INLINE CGFloat GTReHeightFloat(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    height = height*1096/(mainFrme.size.height*2);
    return height;
}

CG_INLINE CGFloat GTFixWidthFloat(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*mainFrme.size.width/640*2;
    return width;
}

CG_INLINE CGFloat GTReWidthFloat(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*640/mainFrme.size.width/2;
    return width;
}

// 经过测试了, 以iphone5屏幕为适配基础
CG_INLINE CGRect
GTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = GTFixWidthFloat(width); rect.size.height = GTFixWidthFloat(height);
    return rect;
}


#endif
