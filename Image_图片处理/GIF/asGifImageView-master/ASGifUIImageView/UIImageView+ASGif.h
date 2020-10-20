//
//  UIImageView+ASGif.h
//  ASGifUIImageView
//
//  Created by ashen on 16/4/14.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImageView (ASGif)
- (void)showGifImageWithData:(NSData *)data;
- (void)showGifImageWithURL:(NSURL *)url;
@end
