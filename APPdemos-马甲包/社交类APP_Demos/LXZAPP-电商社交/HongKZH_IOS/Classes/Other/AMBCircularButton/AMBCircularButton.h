//
//  AMBCircularButton.h
//  AMBCircularButton
//
//  Created by amb on 28/02/14.
//  Copyright (c) 2014 AMB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import <SDWebImage/UIButton+WebCache.h>
#import "UIButton+WebCache.h"

@interface AMBCircularButton : UIButton

/**
 Sets an UIImage to the circular button.
 
 @param image An image to set.
 @param state The state of the button.
 */
- (void)setCircularImage:(UIImage *)image
                forState:(UIControlState)state;

- (void)setCircularImageWithURL:(NSURL *)imageURL
                       forState:(UIControlState)state;
- (void)setCircularImageWithURL:(NSURL *)imageURL
                       forState:(UIControlState)state
               placeholderImage:(UIImage *)placeholder;
- (void)setCircularImageWithURL:(NSURL *)imageURL
                       forState:(UIControlState)state
               placeholderImage:(UIImage *)placeholder
                        options:(SDWebImageOptions)options;

@end
