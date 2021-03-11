//
//  ZQCropView.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQCropView.h"
#import "ViewUtils.h"

static const CGFloat kMaskAlpha = 0.4f;

@interface ZQCropView ()

@end
@implementation ZQCropView

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        self.cropRect = CGRectMake(0, (frame.size.height-frame.size.width)/2, frame.size.width, frame.size.width);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        UIBezierPath *cropPath = [UIBezierPath bezierPathWithRect:self.cropRect];
        [path appendPath:cropPath];
        
        CAShapeLayer *square = [CAShapeLayer layer];
        [square setLineWidth:1.0];
        [square setStrokeColor:[UIColor whiteColor].CGColor];
        [square setFillColor:[UIColor clearColor].CGColor];
        square.path = cropPath.CGPath;
        
        // Shape layer mask
        CAShapeLayer *mask = [CAShapeLayer layer];
        [mask setFillRule:kCAFillRuleEvenOdd];
        [mask setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:kMaskAlpha] CGColor]];
        [self.layer addSublayer:mask];
        [self.layer addSublayer:square];
        mask.path = path.CGPath;

    }
    return self;
}

- (void)cancel {
    UIViewController *vc = [self firstViewController];
    [vc.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
