//
//  G2XRoundButton.m
//  italker
//
//  Created by XuxingGuo on 14/10/27.
//  Copyright (c) 2014年 verywill. All rights reserved.
//

#import "G2XRoundButton.h"

#define G2X_ROUNDBUTTON_CORNER_X [self corner_x]
#define G2X_ROUNDBUTTON_CORNER_Y [self corner_y]

@interface G2XRoundButton ()



@property (nonatomic,retain) UIImage* bgImageNormal;
@property (nonatomic,retain) UIImage* bgImageSelected;
@property (nonatomic,retain) UIImage* bgImageHighlight;
@property (nonatomic,retain) UIImage* bgImageDisable;

@end
@implementation G2XRoundButton

- (CGFloat) corner_x
{
    return 10;
}
- (CGFloat) corner_y
{
    return 10;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.bgImageNormal == nil) {
        UIImage* img = [self backgroundImageForState:UIControlStateNormal];
        if (img != nil) {
            self.bgImageNormal = [img stretchableImageWithLeftCapWidth:G2X_ROUNDBUTTON_CORNER_X topCapHeight:G2X_ROUNDBUTTON_CORNER_Y];
            [self setBackgroundImage:self.bgImageNormal forState:UIControlStateNormal];
        }
    }
    if (self.bgImageSelected == nil) {
        UIImage* img = [self backgroundImageForState:UIControlStateSelected];
        if (img != nil) {
            self.bgImageSelected = [img stretchableImageWithLeftCapWidth:G2X_ROUNDBUTTON_CORNER_X topCapHeight:G2X_ROUNDBUTTON_CORNER_Y];
            [self setBackgroundImage:self.bgImageSelected forState:UIControlStateSelected];
        }
    }
    if (self.bgImageHighlight == nil) {
        UIImage* img = [self backgroundImageForState:UIControlStateHighlighted];
        if (img != nil) {
            self.bgImageHighlight = [img stretchableImageWithLeftCapWidth:G2X_ROUNDBUTTON_CORNER_X topCapHeight:G2X_ROUNDBUTTON_CORNER_Y];
            [self setBackgroundImage:self.bgImageHighlight forState:UIControlStateHighlighted];
        }
    }
    if (self.bgImageDisable == nil) {
        UIImage* img = [self backgroundImageForState:UIControlStateDisabled];
        if (img != nil) {
            self.bgImageDisable = [img stretchableImageWithLeftCapWidth:G2X_ROUNDBUTTON_CORNER_X topCapHeight:G2X_ROUNDBUTTON_CORNER_Y];
            [self setBackgroundImage:self.bgImageDisable forState:UIControlStateDisabled];
        }
    }
}

@end


@implementation G2XRoundButton6

- (CGFloat) corner_x
{
    return 6;
}
- (CGFloat) corner_y
{
    return 6;
}

@end
@implementation G2XRoundButton8

- (CGFloat) corner_x
{
    return 32;
}
- (CGFloat) corner_y
{
    return 8;
}

@end

@implementation G2XRoundButton15

- (CGFloat) corner_x
{
    return 15;
}
- (CGFloat) corner_y
{
    return 15;
}

@end

@implementation G2XRoundButton20

- (CGFloat) corner_x
{
    return 20;
}
- (CGFloat) corner_y
{
    return 20;
}

@end
