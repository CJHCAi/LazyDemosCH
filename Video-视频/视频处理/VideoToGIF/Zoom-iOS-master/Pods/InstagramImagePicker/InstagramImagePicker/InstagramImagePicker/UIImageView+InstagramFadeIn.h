//
//  UIImageView+InstagramFadeIn.h
//  InstagramImagePicker
//
//  Created by Deon Botha on 23/03/2015.
//  Copyright (c) 2015 Deon Botha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (InstagramFadeIn)
- (void)setAndFadeInInstagramImageWithURL:(NSURL *)url;
- (void)setAndFadeInInstagramImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholder;
@end