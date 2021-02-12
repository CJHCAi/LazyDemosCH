//
//  Deck.m
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/4/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *majiangs;
@end


@implementation Deck

- (NSMutableArray *)majiangs{
    if (!_majiangs) _majiangs = [[NSMutableArray alloc] init];
    return _majiangs;
}

- (void)addMajiang:(Majiang *)majiang atTop:(BOOL)atTop
{
    if (atTop) {
        [self.majiangs insertObject:majiang atIndex:0];
    } else {
        [self.majiangs addObject:majiang];
    }
}

- (void)addMajiang:(Majiang *)majiang
{
    [self addMajiang:majiang atTop:NO];
    
}

- (Majiang *)drawRandomMajiang
{
    Majiang *randomMajiang = nil;
    
    if ([self.majiangs count])
    {
        unsigned index = arc4random() % [self.majiangs count];
        randomMajiang = self.majiangs[index];
        [self.majiangs removeObjectAtIndex:index];
    }
    return randomMajiang;
}


@end
