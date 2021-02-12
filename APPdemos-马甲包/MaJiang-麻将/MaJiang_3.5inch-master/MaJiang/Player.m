//
//  Player.m
//  MaJiang
//
//  Created by yu_hao on 1/7/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init {
    self = [super init];
    if (self) {
        _online = 1;
        _jiao = 1;
        _pointsForAction = 0;
        _points = 0;
        _name = @"player1";
        _displayName = @"用户";
    }
    return self;
}

@end
