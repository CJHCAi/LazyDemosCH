//
//  YIMEditerAccessoryMenuItem.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerAccessoryMenuItem.h"


@implementation YIMEditerAccessoryMenuItem
-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}
-(UIView*)menuItemInputView{
    return nil;
}
-(BOOL)clickAction{
    return true;
}
@end
