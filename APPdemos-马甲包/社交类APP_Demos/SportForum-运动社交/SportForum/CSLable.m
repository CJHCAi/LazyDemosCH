//
//  CSLable.m
//  H850Samba
//
//  Created by zhengying on 3/29/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "CSLable.h"

@implementation CSLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
