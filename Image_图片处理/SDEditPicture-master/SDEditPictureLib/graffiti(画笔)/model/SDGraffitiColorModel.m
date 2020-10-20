//
//  SDGraffitiColorModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiColorModel.h"

@implementation SDGraffitiColorModel

- (instancetype)initWithColor:(UIColor *)graffitiColor
{
    self = [super init];
    if (self) {
        _graffitiColor = graffitiColor;
    }
    return self;
}

@end
