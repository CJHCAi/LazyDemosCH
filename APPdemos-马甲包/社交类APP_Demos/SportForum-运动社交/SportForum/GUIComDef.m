//
//  GUIComDef.m
//  DrivingTour
//
//  Created by zhengying on 1/8/14.
//  Copyright (c) 2014 ice139. All rights reserved.
//
#import "GUIComDef.h"

CGRect CGRectSetX(CGRect rect, CGFloat x) {
    CGRect newRect = rect;
    newRect = CGRectMake(x, newRect.origin.y, newRect.size.width, newRect.size.height);
    return newRect;
}

CGRect CGRectSetY(CGRect rect, CGFloat y) {
    CGRect newRect = rect;
    newRect = CGRectMake(newRect.origin.x, y, newRect.size.width, newRect.size.height);
    return newRect;
}

CGRect CGRectSetWidth(CGRect rect, CGFloat w) {
    CGRect newRect = rect;
    newRect = CGRectMake(newRect.origin.x, newRect.origin.y, w, newRect.size.height);
    return newRect;
}

CGRect CGRectSetHeight(CGRect rect, CGFloat h) {
    CGRect newRect = rect;
    newRect = CGRectMake(newRect.origin.x, newRect.origin.y, newRect.size.width, h);
    return newRect;
}

