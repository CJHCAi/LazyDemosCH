//
//  AGMoviePlayerViewController.h
//  75AG驾校助手
//
//  Created by again on 16/5/12.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AGMoviewPlayerViewControllerDelegate <NSObject>

- (void)moviePlayerDidFinished;
- (void)moviePlayerDidCapturedWithImage:(UIImage *)image;

@end

@interface AGMoviePlayerViewController : UIViewController

@property (weak,nonatomic) id<AGMoviewPlayerViewControllerDelegate> delegate;

@property (strong,nonatomic) NSURL *movieUrl;
- (void)captureImageAtTime:(float)time;

@end
