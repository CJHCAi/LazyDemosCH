//
//  CustomTableView.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-6.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&

        [self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    
    {
        
        [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
    
    }
}
@end
