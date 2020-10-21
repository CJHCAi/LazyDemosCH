//
//  SNHRulerView.m
//  SNHRulerView
//
//  Created by 黄淑妮 on 2017/6/15.
//  Copyright © 2017年 Mirco. All rights reserved.
//

#import "SNHRulerView.h"

@implementation SNHRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(NO, nil);
    @throw nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithFrame:(CGRect)frame widthPerSecond:(CGFloat)width themeColor:(UIColor *)color labelInterval:(NSInteger)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        _widthPerSecond = width;
        _themeColor = color;
        _labelInterval = interval;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat leftMargin = 10;
    CGFloat topMargin = 0;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat minorTickSpace = self.widthPerSecond;
    NSInteger multiple = _labelInterval;
    CGFloat majorTickLength = 12;
    CGFloat minorTickLength = 7;
    
    CGFloat baseY = topMargin + height;
    CGFloat minorY = baseY - minorTickLength;
    CGFloat majorY = baseY - majorTickLength;
    
    NSInteger step = 0;
    BOOL shoudSkip = minorTickSpace < 4.75 ? YES : NO;
    NSInteger skipCount = 5;
    for (CGFloat x = leftMargin; x <= (leftMargin + width); x += minorTickSpace) {
        
        CGContextMoveToPoint(context, x, baseY);
        
        void (^drawElement)() = ^() {
            CGContextSetFillColorWithColor(context, self.themeColor.CGColor);
            if (step % multiple == 0) {
                CGContextFillRect(context, CGRectMake(x, majorY, 1.75, majorTickLength));
                
                UIFont *font = [UIFont systemFontOfSize:11];
                UIColor *textColor = self.themeColor;
                NSDictionary *stringAttrs = @{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor};
                
                NSInteger minutes = step / 60;
                NSInteger seconds = step % 60;
                
                NSAttributedString* attrStr;
                
                if (minutes > 0) {
                    attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld:%02ld", (long) minutes, (long) seconds] attributes:stringAttrs];
                }
                else {
                    attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%02ld", (long) seconds] attributes:stringAttrs];
                }
                
                [attrStr drawAtPoint:CGPointMake(x-7, majorY - 15)];
                
                
            } else {
                CGContextFillRect(context, CGRectMake(x, minorY, 1.0, minorTickLength));
            }
        };
        
        
        if (!shoudSkip) {
            drawElement();
        } else if (shoudSkip && skipCount == 5) {
            skipCount = 0;
            drawElement();
            
        } else {
            skipCount++;
        }
        
        step++;
    }
}

#pragma mark - Private methods

- (CGFloat)widthPerSecond
{
    return _widthPerSecond ?: 25.0;
}

- (UIColor *)themeColor
{
    return _themeColor ?: [UIColor lightGrayColor];
}


@end
