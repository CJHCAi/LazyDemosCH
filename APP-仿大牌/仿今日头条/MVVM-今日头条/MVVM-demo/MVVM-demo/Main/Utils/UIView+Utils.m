//
//  UIView+Utils.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (CGFloat)current_x{
    return self.frame.origin.x;
}
- (CGFloat)current_y{
    return self.frame.origin.y;
}
- (CGFloat)current_w{
    return self.frame.size.width;
}
- (CGFloat)current_h{
    return self.frame.size.height;
}
- (CGFloat)current_x_w{
    return self.frame.origin.x+self.frame.size.width;
}
- (CGFloat)current_y_h{
    return self.frame.origin.y+self.frame.size.height;
}

@end
