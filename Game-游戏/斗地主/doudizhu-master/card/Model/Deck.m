//
//  Deck.m
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [NSMutableArray new];
    }
    return _cards;
}

- (void)addCard:(Card *)card
{
    [self.cards addObject:card];
}

- (Card *)getRandomCard
{
    Card *randomCard;
    if (self.cards.count) {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

- (NSInteger)getCardTotals
{
    return self.cards.count;
}

@end
