//
//  CTTools.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/7/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZQTools : NSObject

+ (UIImage*)createImageWithColor:(UIColor*) color;
+ (UIImage *)image:(UIImage*)image withTintColor:(UIColor *)tintColor;
+ (UIViewController* )rootViewController;
@end
