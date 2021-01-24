//
//  WenzhouMajiang.m
//  Wenzhoumajiang
//
//  Created by Leixiang Wu on 4/5/14.
//  Copyright (c) 2014 WildCoders. All rights reserved.
//

#import "WenzhouMajiang.h"

@interface WenzhouMajiang ()

@end

@implementation WenzhouMajiang

- (NSString *)contents{
    return [self.suit stringByAppendingString:self.rank];
}

+ (NSArray *)validSuits{
    return @[@"character", @"circle", @"bamboo", @"wind", @"dragon"];
}

+ (NSArray *)validBambooRank{
    return @[@"?", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
}

+ (NSArray *)validCharacterRank{
    return @[@"?", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
}

+ (NSArray *)validCircleRank{
    return @[@"?", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
}

+ (NSArray *)validDragonRank{
    return @[@"?", @"red",@"green", @"white"];
}

+ (NSArray *)validWindRank{
    return @[@"?", @"east", @"west", @"south", @"north"];
}

- (void)setRank:(NSString *)rank
{
    if ([self.suit isEqualToString:@"bamboo"])
    {
        if ([[WenzhouMajiang validBambooRank] containsObject:rank])
            _rank = rank;
    } else if ([self.suit isEqualToString:@"character"])
    {
            if ([[WenzhouMajiang validCharacterRank]containsObject:rank])
                _rank = rank;
    } else if ([self.suit isEqualToString:@"circle"])
    {
        if ([[WenzhouMajiang validCircleRank]containsObject:rank])
            _rank = rank;
    } else if ([self.suit isEqualToString:@"dragon"])
    {
        if ([[WenzhouMajiang validDragonRank]containsObject:rank])
            _rank = rank;
    } else if ([self.suit isEqualToString:@"wind"])
    {
        if ([[WenzhouMajiang validWindRank]containsObject:rank])
            _rank = rank;
    }
}


- (void)setSuit:(NSString *)suit{
    if ([[WenzhouMajiang validSuits] containsObject:suit])
    {
        self.suit = suit;
    }
}


@end
