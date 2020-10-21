//
//  BigPreviewImageView.m
//  
//
//  Created by Rick on 15/5/27.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "BigPreviewImageView.h"
#import "ImageCropperView.h"

@implementation BigPreviewImageView


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    NSArray *array = hitView.superview.subviews;
    if (!_isIrregular) {
        return hitView;
    }else{
        
        if (array.count>0) {
            for (UIView *view in array) {
                if ([view isKindOfClass:[ImageCropperView class]]) {
                    return nil;
                }
            }
        }
        return self;
    }
    return self;
}

@end
