//
//  HomeTextView.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/22.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "HomeTextView.h"

@implementation HomeTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = NO;
        self.editable = NO;
        self.layer.borderWidth = 1;
        self.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){244/255.0,244/255.0,244/255.0,1});
        [self setFont:[UIFont fontWithName:@"HannotateSC-W5" size:14]];
    }
    return self;
}

@end
