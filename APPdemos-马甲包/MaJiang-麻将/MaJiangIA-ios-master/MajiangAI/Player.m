//
//  Player.m
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)init
{
    self = [super init];
    if ( self ){
        _handMjs = [NSMutableArray array];
        _isSuccess = 0;
        _status = WaitStatus;
    }
    return self;
}

- (void)addOneMj:(singleMajiangNode *)mj
{
    [_handMjs addObject:mj];
}


@end
