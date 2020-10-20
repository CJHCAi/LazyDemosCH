//
//  UIView+CateGory.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "UIView+CateGory.h"

@implementation UIView (CateGory)

- (BOOL)containssubviewOfClassType:(Class)cls{
    
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:cls]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeAllsubViews{
    for (id temp  in self.subviews) {
        [temp removeFromSuperview];
    }
}


- (void)removeSubviewsWithSubviewClass:(Class)cls{
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
}
- (CGPoint)origin{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}
- (CGFloat)X{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)X{
    self.frame = CGRectMake(X, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)Y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)Y{
    self.frame = CGRectMake(self.frame.origin.x, Y, self.frame.size.width, self.frame.size.height);
    
}
- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right{
    self.frame = CGRectMake(right- self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)bottom{
    return self.frame.origin.y+self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom- self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
-(CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y, width, self.frame.size.height);
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x
                            , self.frame.origin.y, self.frame.size.width, height);
}
- (CGRect)midframewithheight:(CGFloat)height width:(CGFloat)width{
    return CGRectMake((self.width - width)/2, (self.height - height)/2, width, height);
}
+ (UINib *)nib{
    return [UINib nibWithNibName:NSStringFromClass([ self class]) bundle:[NSBundle mainBundle]];
}
+ (instancetype)instanceFromNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])owner:nil options:nil] lastObject];
}
@end
