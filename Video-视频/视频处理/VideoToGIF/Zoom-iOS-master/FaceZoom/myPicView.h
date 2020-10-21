//
//  myPicView.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/18/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//


#import <UIKit/UIKit.h>

//@class ViewController;


@interface myPicView : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *myPicView;
@property (strong, nonatomic) UIImage *myImage;

@end
