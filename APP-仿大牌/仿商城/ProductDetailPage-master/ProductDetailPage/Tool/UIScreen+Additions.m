//
//  UIScreen+Additions.m
//  ZhongHeBao
//
//  Created by yangyang on 2017/9/19.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import "UIScreen+Additions.h"

@implementation UIScreen (Additions)

- (CGSize)size {
    return self.bounds.size;
}

- (CGFloat)height {
    return self.size.height;
}

- (CGFloat)width {
    return self.size.width;
}

+ (CGRect)bounds {
    return UIScreen.mainScreen.bounds;
}

+ (CGSize)size {
    return UIScreen.mainScreen.size;
}

+ (CGFloat)width {
    return UIScreen.size.width;
}

+ (CGFloat)height {
    return UIScreen.size.height;
}

+ (NSString *)resolution {
    CGFloat scale = [[UIScreen mainScreen] scale];
    return [NSString stringWithFormat:@"%ldx%ld",(long)(UIScreen.width * scale), (long)(UIScreen.height * scale)];
}

+ (CGFloat)statusBarHeight {
    return UI_IS_IPHONEX ? 44 : 20;
}

+ (CGFloat)navigationBarHeight {
    return UI_IS_IPHONEX ? 88 : 64;
}

+ (CGFloat)tabBarHeight {
    return UI_IS_IPHONEX ? 83 : 49;
}

+ (CGFloat)safeBottomMargin {
    return UI_IS_IPHONEX ? 34 : 0;
}

@end
