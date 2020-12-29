//
//  SFGridViewCell.m
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "SFGridViewCell.h"

@implementation SFGridMainViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _strDirection = @"Vertical";
    }
    return self;
}

@end

@implementation SFGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
