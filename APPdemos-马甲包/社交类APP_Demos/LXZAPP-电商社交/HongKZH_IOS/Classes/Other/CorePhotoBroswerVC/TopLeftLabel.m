//
//  TopLeftLabel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "TopLeftLabel.h"

@implementation TopLeftLabel

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
    
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y; return textRect;
    
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
    
}



@end
