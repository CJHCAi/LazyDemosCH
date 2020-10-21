//
//  OverlayView.h
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

//拐角
@property (readonly) CGRect topLeftCorner;
@property (readonly) CGRect topRightCorner;
@property (readonly) CGRect bottomLeftCorner;
@property (readonly) CGRect bottomRightCorner;
//边缘
@property (readonly) CGRect topEdgeRect;
@property (readonly) CGRect rightEdgeRect;
@property (readonly) CGRect bottomEdgeRect;
@property (readonly) CGRect leftEdgeRect;
//基准透明区域，不可赋初始值
@property (nonatomic, assign) CGRect clearRect;

//透明区域数组
@property (nonatomic, strong) NSMutableArray *rectArray;

//焦点透明区域
@property (nonatomic, assign) NSInteger whichRect;

@property (nonatomic, assign) CGSize maxSize;

- (BOOL)isCornerContainsPoint:(CGPoint)point;

- (BOOL)isEdgeContainsPoint:(CGPoint)point;

- (BOOL)isInRectPoint:(CGPoint)point;

@end
