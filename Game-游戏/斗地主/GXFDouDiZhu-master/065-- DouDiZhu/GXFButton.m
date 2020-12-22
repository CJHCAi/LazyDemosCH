//
//  GXFButton.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/24.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "GXFButton.h"
#import <objc/runtime.h>

const void *key = @"key";
@implementation GXFButton

- (void)setIsUp:(NSString *)isUp {
    
    objc_setAssociatedObject(self, key, isUp, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)isUp {
    
    return objc_getAssociatedObject(self, key);
}

- (void)moveToWindow {
    
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.transform = CGAffineTransformMakeTranslation(0, -200);
}

@end
