//
//  Majiang.m
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/4/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import "Majiang.h"

@implementation Majiang


- (BOOL)match:(NSArray *)otherMajiangs
{
    for (Majiang *otherMajiang in otherMajiangs)
    {
        if ([otherMajiang.contents isEqualToString:self.contents]) {
            return true;
        }
    }
    return false;
}

@end
