//
//  CCPCalendarButton.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/25.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "CCPCalendarButton.h"

@interface CCPCalendarButton()
{
    CGFloat fontSize;
    CAShapeLayer *sl;
    CAShapeLayer *sMask;
    CAShapeLayer *eMask;
    CAShapeLayer *otherMask;
    CALayer *orginMask;
}
@end

@implementation CCPCalendarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        fontSize = 14.0 * scale_w;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setBackgroundColor:[UIColor clearColor]];
        [self addTarget:self action:@selector(action:event:) forControlEvents:UIControlEventAllTouchEvents];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        orginMask = self.layer.mask;
        [self sMask];
        [self eMask];
        [self otherMask];
    }
    return self;
}

- (void)addObesers {
    if (self.manager.selectType == select_type_multiple) {
        [self addObserver:self forKeyPath:@"manager.endTag" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
    if ([self.manager.postionDate isSameTo:self.date]) {
        self.selected = YES;
        [self.manager.selectBtns addObject:self];
        [self.manager.selectArr addObject:self.date];
    }
}

- (void)ccpDispaly {
    if ([self.date isSameTo:self.manager.createDate]) {
        [self setTitleColor:rgba(255, 30, 30, 1.0) forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:self.manager.normal_text_color forState:UIControlStateNormal];
    }
    [self setTitleColor:self.manager.selected_text_color forState:UIControlStateSelected];
    [self setTitleColor:self.manager.disable_text_color forState:UIControlStateDisabled];
    if ([self.date earlyThan:self.manager.createDate]) {
        self.enabled = NO;
    }
    else {
        self.enabled = YES;
    }
    if (self.manager.isShowPast) {
        self.enabled = YES;
    }
    if (self.manager.dateEnableRange.count > 0) {
        NSCAssert(self.manager.dateEnableRange.count == 2, @"dateEnableRange count must equal to 2");
        if ([self.date earlyThan:self.manager.dateEnableRange.firstObject]) {
            self.enabled = NO;
        }
        else if ([self.manager.dateEnableRange.lastObject earlyThan:self.date]) {
            self.enabled = NO;
        }
    }
    [self cirPath];
    if (self.manager.createEndDate) {
        if ([self.manager.createEndDate earlyThan:self.date] || [self.manager.createEndDate isSameTo:self.date]) {
            self.enabled = YES;
        }
        else {
            self.enabled = NO;
        }
    }
    if ([self.date isSameTo:self.manager.selectDate]) {
        self.selected = YES;
        sl.fillColor = rgba(255, 255, 255, 1.0).CGColor;
        if (self.manager.click) {
            self.manager.click(self);
        }
    }

}

- (void)action:(UIButton *)Bbtn event:(UIEvent *)event {
    if (Bbtn.selected == NO) {
        UITouchPhase tp = event.allTouches.anyObject.phase;
        if (tp == UITouchPhaseBegan) {
            sl.fillColor = rgba(255, 255, 255, 0.5).CGColor;
            sl.transform = CATransform3DMakeScale(1.2, 1.2, 1.0);
        }
        else if (tp == UITouchPhaseEnded) {
            sl.transform = CATransform3DIdentity;
            Bbtn.selected = YES;
            if (self.manager.click) {
                self.manager.click(self);
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id obj = change[NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"selected"]) {
        if ([obj boolValue]) {
            sl.fillColor = [UIColor whiteColor].CGColor;
        }
        else {
            sl.fillColor = [UIColor clearColor].CGColor;
        }
    }
    else if ([keyPath isEqualToString:@"manager.endTag"]) {
        if ([obj integerValue] != 0) {
            self.backgroundColor = rgba(255, 255, 255, 0.2);;
            if (self.tag == self.manager.startTag) {
                self.layer.mask = sMask;
                
            }
            else if (self.tag > self.manager.startTag && self.tag < self.manager.endTag) {
                self.layer.mask = otherMask;
            }
            else if (self.tag == self.manager.endTag) {
                self.layer.mask = eMask;
            }
            else {
                self.backgroundColor = [UIColor clearColor];
            }
        }
        else {
            self.backgroundColor = [UIColor clearColor];
            self.layer.mask = orginMask;
        }
    }
    else if ([keyPath isEqualToString:@"backgroundColor"]) {
        UIColor *color = (UIColor *)obj;
        if (color == [UIColor whiteColor]) {
            
            [self setTitleColor:self.manager.selected_text_color forState:UIControlStateNormal];
        }
        else {if ([self.date isSameTo:self.manager.createDate]) {
            [self setTitleColor:rgba(255, 30, 30, 1.0) forState:UIControlStateNormal];
        }
        else {
            [self setTitleColor:self.manager.normal_text_color forState:UIControlStateNormal];
        }
           // [self setTitleColor:self.manager.normal_text_color forState:UIControlStateNormal];
        }
    }
}


- (void)sMask {
    if (!sMask) {
        CGFloat radius = main_width / 16;
        CGPoint center = CGPointMake(main_width / 14, main_width / 14);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI_2 endAngle:M_PI * 3 / 2 clockwise:YES];
        [path addLineToPoint:CGPointMake(main_width / 7,main_width / 112)];
        [path addLineToPoint:CGPointMake(main_width / 7, main_width / 8 + main_width / 112)];
        [path closePath];
        sMask = [CAShapeLayer layer];
        sMask.path = path.CGPath;
        sMask.fillColor = [UIColor redColor].CGColor;
        
    }
}

- (void)eMask {
    if (!eMask) {
        CGFloat radius = main_width / 16;
        CGPoint center = CGPointMake(main_width / 14, main_width / 14);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:- M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(0, main_width / 8 + main_width / 112)];
        [path addLineToPoint:CGPointMake(0, main_width / 112)];
        [path closePath];
        eMask = [CAShapeLayer layer];
        eMask.path = path.CGPath;
        eMask.fillColor = [UIColor redColor].CGColor;
    }
}

- (void)otherMask {
    if (!otherMask) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, main_width / 112)];
        [path addLineToPoint:CGPointMake(main_width / 7, main_width / 112)];
        [path addLineToPoint:CGPointMake(main_width / 7, main_width / 8 + main_width / 112)];
        [path addLineToPoint:CGPointMake(0, main_width / 8 + main_width / 112)];
        [path closePath];
        otherMask = [CAShapeLayer layer];
        otherMask.path = path.CGPath;
        otherMask.fillColor = [UIColor redColor].CGColor;
    }
}

- (void)cirPath {
    CGFloat radius = main_width / 16;
    CGPoint center = CGPointMake(main_width / 14, main_width / 14);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    sl = [CAShapeLayer layer];
    sl.path = path.CGPath;
    sl.lineWidth = 1.0;
    sl.strokeColor = [UIColor clearColor].CGColor;
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.zPosition = -1;
    sl.bounds = self.bounds;
    sl.position = center;
    [sl setAnchorPoint:CGPointMake(0.5, 0.5)];
//    if ([self.date isSameTo:self.manager.createDate]) {
//        sl.strokeColor = [UIColor whiteColor].CGColor;
//    }
    [self.layer addSublayer:sl];
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"backgroundColor"];
    if (self.manager.selectType == select_type_multiple) {
        [self removeObserver:self forKeyPath:@"manager.endTag"];
    }
}
@end
