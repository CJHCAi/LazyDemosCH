//
//  Utils.h
//  ColorfulFan-iOS
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 ihunuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject

+ (void*)getImageData:(UIImage*)image;

+ (UIColor*) getImageColorFromPostion:(UIImage *)img :(CGPoint)point;

+ (UIColor*) getRandomColor;

+ (NSMutableArray*) getDotsColorFromImageInFan:(CGSize)size : (UIImage*)img;

+ (UIImage *)makeImageWithView:(UIView *)view;

+ (void) removeAllChildrenFromView : (UIView *)view;

+ (NSNumber*) switchUint8:(int)r :(int)g :(int)b;

+ (NSData*)imageTo8Byte:(UIImage *)img;

+ (UIImage*)blackWhite:(UIImage*)inImage;

+(UIImage*)CropImage:(UIImage*)photoimage;

@end
