//
//  PlayingDeck.m
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "PlayingDeck.h"
#import "PlayingCard.h"

@implementation PlayingDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 1; i <= [PlayingCard maxRank]; i ++) {
            for (NSString *suit in [PlayingCard validSuits]) {
                PlayingCard *card = [PlayingCard new];
                card.suit = suit;
                card.rank = i;
                [self addCard:card];
            }
        }
        // 大小王
        PlayingCard *cardLittle = [PlayingCard new];
        cardLittle.rank = [PlayingCard maxRank] + 1;
        cardLittle.contents = @"小王";
        [self addCard:cardLittle];
        PlayingCard *cardBig = [PlayingCard new];
        cardBig.rank = [PlayingCard maxRank] + 2;
        cardBig.contents = @"大王";
        [self addCard:cardBig];
    }
    return self;
}

@end
