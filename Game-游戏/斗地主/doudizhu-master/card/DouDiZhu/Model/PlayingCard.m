//
//  PlayingCard.m
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit, contents = _contents;

+ (NSArray *)rankStrings
{
    return @[@"?", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A", @"2"];
}

+ (NSArray *)validSuits
{
    return @[@"♠︎", @"♥︎", @"♣︎", @"♦︎"];
}

+ (NSUInteger)maxRank
{
    return [PlayingCard rankStrings].count - 1;
}

- (NSString *)contents
{
    if (self.rank > [PlayingCard maxRank]) {
        return _contents;
    }
    return [NSString stringWithFormat:@"%@\n%@", [PlayingCard rankStrings][self.rank], self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"";
}

- (BOOL)biggerThan:(PlayingCard *)card
{
    return self.rank > card.rank;
}

@end
