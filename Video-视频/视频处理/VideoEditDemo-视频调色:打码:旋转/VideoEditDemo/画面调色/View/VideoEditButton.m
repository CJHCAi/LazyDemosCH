//
//  VideoEditButton.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/20.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import "VideoEditButton.h"

@implementation VideoEditButton

-(instancetype)initWithButtonImage:(UIImage *)image ButtonTitle:(NSString *)title{
    self = [super init];
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateDisabled];
        [self setTitle:title forState:UIControlStateDisabled];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.value = 0.0;
        self.canTouch = NO;
    }
    return self;
}

-(void)setCanTouch:(BOOL)canTouch{
    if (canTouch) {
        [self setEnabled:NO];
        [self setAlpha:1.0f];
    }else{
        [self setAlpha:0.5f];
        [self setEnabled:YES];
    }
}


@end
