//
//  VerticalButton.m
//  VerticalText
//
//  Created by horry on 15/9/3.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import "VerticalButton.h"
#import "VerticalLabel.h"
@interface VerticalButton () {
	VerticalLabel *label;
}

@end


@implementation VerticalButton

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	[self initLabel];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (!self) {
		return nil;
	}
	[self initLabel];
	return self;

}

- (void)initLabel {
	label = [[VerticalLabel alloc] init];
	label.frame = self.bounds;
	label.aligment = VerticalTextAligmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.userInteractionEnabled = NO;
	_highlightColor = [UIColor lightGrayColor];
	[self addSubview:label];
	self.backgroundColor = [UIColor clearColor];
}

- (void)setText:(NSString *)text {
	_text = text;
	label.text = text;
}

- (void)setFont:(UIFont *)font {
	_font = font;
	label.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
	_textColor = textColor;
	label.textColor = textColor;
}

- (void)drawRect:(CGRect)rect {
	label.frame = self.bounds;
	[label setNeedsDisplay];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[super beginTrackingWithTouch:touch withEvent:event];
	label.textColor = _highlightColor;
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[super continueTrackingWithTouch:touch withEvent:event];
	if (self.touchInside) {
		[self unHighlight];
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	[super endTrackingWithTouch:touch withEvent:event];
	[self performSelector:@selector(unHighlight) withObject:nil afterDelay:0.3];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	[super cancelTrackingWithEvent:event];
	[self unHighlight];
	
}

- (void)unHighlight {
	label.textColor = self.textColor;
}

@end
