//
//  FaceRect.h
//  FaceView
//
//  Created by Bharath Kumar Devaraj on 7/31/13.
//  Copyright (c) 2013 Bharath Kumar Devaraj. All rights reserved.
//


#import <UIKit/UIKit.h>


#pragma mark ControlPointView interface

@interface ControlPointView : UIView {
    CGFloat red, green, blue, alpha;
}

@property (nonatomic, retain) UIColor* color;

@end


@interface FaceRect : UIView{
    BOOL isResizingLR;
    BOOL isResizingUL;
    BOOL isResizingUR;
    BOOL isResizingLL;
    CGPoint touchStart;
    ControlPointView *myPoint;
    UIImageView *myView;
}
@end