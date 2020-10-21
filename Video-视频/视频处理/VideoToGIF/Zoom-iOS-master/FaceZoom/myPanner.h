//
//  myPanner.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/18/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ViewController;


@interface myPanner : UIPanGestureRecognizer{

    CGPoint originPosition;
    
}

- (CGPoint) touchPointInView:(UIView *)view;

- (void) incrementOrigin:(CGPoint *)incrementPoint;

@end
