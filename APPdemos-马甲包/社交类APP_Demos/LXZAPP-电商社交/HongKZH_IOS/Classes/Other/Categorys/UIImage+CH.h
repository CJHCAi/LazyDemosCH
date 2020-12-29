//
//  UIImage+CH.h
//  XiYou_IOS
//
//  Created by regan on 15/11/19.
//  Copyright © 2015年 regan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define ImageScale 0.2
#define LogoImageMargin 5

@interface UIImage (CH)
+(UIImage *)resizedImage:(NSString *)name;
+(UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


//截屏方法
+(instancetype)renderView:(UIView *)renderView;
//图片家水印
+(instancetype)waterWithBgName:(NSString *)bg waterLogo:(NSString *)water;
//裁剪图片为园
+(instancetype)clipWithImageName:(NSString*)name bordersW:(CGFloat)bordersW borderColor:(UIColor *)borderColor;


+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height;

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;
@end

