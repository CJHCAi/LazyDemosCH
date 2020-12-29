//
//  RoundButton.m
//  SportForum
//
//  Created by zhengying on 7/14/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initGUI];
    }
    return self;
}

-(void)initGUI {
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
}


-(void)awakeFromNib {
    [self initGUI];
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
