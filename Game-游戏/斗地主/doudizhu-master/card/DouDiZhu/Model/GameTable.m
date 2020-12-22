//
//  GameTable.m
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "GameTable.h"
#import "PlayingCard.h"

@implementation NSObject(GameTable)

- (BOOL)isEqualCard:(id)object
{
    return ((PlayingCard *)self).rank == ((PlayingCard *)object).rank;
}

@end

#pragma mark - 排序 判断

@implementation NSArray(GameTable)

- (NSArray *)sortCards
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(PlayingCard *c1, PlayingCard *c2){
        NSComparisonResult result = [@(c1.rank) compare:@(c2.rank)];
        if (result == NSOrderedSame) {
            return [c1.suit compare:c2.suit];
        }
        else {
            return result;
        }
    }];
}

- (OutCardsOtherType)isSingle
{
    return Single;
}
- (OutCardsOtherType)isDouble
{
    if ([self.firstObject isEqualCard:self.lastObject]) {
        return Double;
    }
    return 0;
}
- (OutCardsOtherType)isThree
{
    if ([self.firstObject isEqualCard:self.lastObject]) {
        return Three;
    }
    return 0;
}
- (OutCardsOtherType)isThreeAndOne
{
    // AAAB or ABBB
    if ([self[0] isEqualCard:self[2]] || [self[1] isEqualCard:self[3]]) {
        return ThreeAndOne;
    }
    return 0;
}
- (OutCardsOtherType)isThreeAndDouble
{
    // AAABB or AABBB
    if (([self[0] isEqualCard:self[2]] && [self[3] isEqualCard:self[4]]) || ([self[0] isEqualCard:self[1]] && [self[2] isEqualCard:self[4]])) {
        return ThreeAndDouble;
    }
    return 0;
}
- (OutCardsOtherType)isStraight
{
    for (int i = 1; i < self.count; i ++) {
        // 值比上一个大1 且小于max（也就是小于2，不是主）
        if (((PlayingCard *)self[i]).rank != ((PlayingCard *)self[i - 1]).rank + 1 || ((PlayingCard *)self[i]).rank >= [PlayingCard maxRank]) {
            return 0;
        }
    }
    return Straight;
}
- (OutCardsOtherType)isMoreDouble
{
    if (self.count % 2 != 0) {
        return 0;
    }
    // 值比上一个大1 跟下一个相等 且小于max（也就是小于2，不是主）
    for (int i = 0; i < self.count; i += 2) {
        if (![self[i] isEqualCard:self[i + 1]] || ((PlayingCard *)self[i]).rank >= [PlayingCard maxRank]) {
            return 0;
        }
        if (i) {
            if (((PlayingCard *)self[i - 1]).rank + 1 != ((PlayingCard *)self[i]).rank) {
                return 0;
            }
        }
    }
    return MoreDouble;
}
- (OutCardsOtherType)isFourAndTwo
{
    if (self.count != 6) {
        return 0;
    }
    // AAAABC or ABBBBC or ABCCCC
    for (int i = 0; i < 3; i ++) {
        if ([self[i] isEqualCard:self[i + 3]]) {
            return FourAndTwo;
        }
    }
    return 0;
}
- (OutCardsOtherType)isFourAndTwoDouble
{
    if (self.count != 8) {
        return 0;
    }
    // AAAABBCC or AABBBBCC or AABBCCCC
    for (int i = 0; i < 6; i += 2) {
        if ([self[i] isEqualCard:self[i + 3]]) {
            for (int j = 0; j < self.count; j += 2) {
                if (![self[j] isEqualCard:self[j + 1]] || ((PlayingCard *)self[j]).rank >= [PlayingCard maxRank]) {
                    return 0;
                }
            }
            return FourAndTwo;
        }
    }
    return 0;
}
- (OutCardsOtherType)isPlane
{
    if (self.count % 3 != 0) {
        return 0;
    }
    for (int i = 0; i < self.count; i += 3) {
        if (![self[i] isEqualCard:self[i + 2]] || ((PlayingCard *)self[i]).rank >= [PlayingCard maxRank]) {
            return 0;
        }
        if (i) {
            if (((PlayingCard *)self[i - 1]).rank + 1 != ((PlayingCard *)self[i]).rank) {
                return 0;
            }
        }
    }
    return Plane;
}
- (OutCardsOtherType)isPlaneAndOne
{
    if (self.count % 4 != 0) {
        return 0;
    }
    NSMutableArray *plane = [self findThree];
    if (self.count != plane.count * 4) {
        return 0;
    }
    for (int i = 0; i < plane.count - 1; i ++) {
        if ([plane[i] integerValue] + 1 != [plane[i + 1] integerValue]) {
            return 0;
        }
    }
    return PlaneAndOne;
}
- (OutCardsOtherType)isPlaneAndDouble
{
    if (self.count % 5 != 0) {
        return 0;
    }
    NSMutableArray *plane = [self findThree];
    NSMutableArray *other = [NSMutableArray new];
    if (self.count != plane.count * 5) {
        return 0;
    }
    for (int i = 0; i < plane.count - 1; i ++) {
        if ([plane[i] integerValue] + 1 != [plane[i + 1] integerValue]) {
            return 0;
        }
    }
    for (int i = 0; i < self.count; i ++) {
        if (![plane containsObject:@(((PlayingCard *)self[i]).rank)]) {
            [other addObject:self[i]];
        }
    }
    for (int i = 0; i < other.count; i += 2) {
        if (![other[i] isEqualCard:other[i + 1]]) {
            return 0;
        }
    }
    
    return PlaneAndDouble;
}

- (NSMutableArray *)findThree
{
    int repeatNum = 1;
    NSInteger tempRank = 0;
    NSMutableArray *plane = [NSMutableArray new];
    // 找出所有三个的
    for (int i = 0; i < self.count; i ++) {
        if (tempRank == ((PlayingCard *)self[i]).rank) {
            repeatNum ++;
            if (repeatNum == 3) {
                repeatNum = 1;
                [plane addObject:@(tempRank)];
            }
        }
        else {
            repeatNum = 1;
            tempRank = ((PlayingCard *)self[i]).rank;
        }
    }
    return plane;
}

- (PlayingCard *)findSmallForMoreCards
{
    NSMutableArray *ary = [self findThree];
    PlayingCard *card;
    NSLog(@"card-->>%lu",(unsigned long)card.rank);
    for (PlayingCard *card1 in ary) {
        if (card.rank > card1.rank) {
            card = card1;
        }
    }
    return card;
}

@end

@interface GameTable ()

@end

@implementation GameTable

#pragma mark - 判断牌类型

+ (OutCardsType)judgeOutCardsTypeFor:(NSArray *)cards
{
    // !! 确保顺序 从小到大
    cards = [cards sortCards];
    if (cards.count == 2 && ((PlayingCard *)cards.firstObject).rank > [PlayingCard maxRank] && ((PlayingCard *)cards.lastObject).rank > [PlayingCard maxRank]) {
        return KingBomb;
    }
    if (cards.count == 4) {
        if (((PlayingCard *)cards.firstObject).rank == ((PlayingCard *)cards.lastObject).rank) {
            return Bomb;
        }
    }
    return Other;
}

// 单牌1，对2，三个3，三带一4，三带对5，四带二6，顺子5个起>=5，连对3个起>=6，飞机>=6，飞机带一>=8，飞机带对>=10
+ (OutCardsOtherType)judgeOutCardsOtherTypeFor:(NSArray *)cards
{
    cards = [cards sortCards];
    switch (cards.count) {
        case 0:
            return 0;
        case 1:
            // 单牌
            return [cards isSingle];
        case 2:
            // 对
            return [cards isDouble];
        case 3:
            // 三个
            return [cards isThree];
        case 4:
            // 三带一
            return [cards isThreeAndOne];
        case 5:
            // 顺子 或者是 三带对
            if ([cards isStraight]) {
                return Straight;
            }
            else if ([cards isThreeAndDouble]) {
                return ThreeAndDouble;
            }
            break;
        case 6:
            // 连对、顺子、飞机、四带二
            if ([cards isMoreDouble]) {
                return MoreDouble;
            }
            else if ([cards isStraight]) {
                return Straight;
            }
            else if ([cards isPlane]) {
                return Plane;
            }
            else if ([cards isFourAndTwo]) {
                return FourAndTwo;
            }
            break;
            
        default:
            // 连对、顺子、飞机3、四带对
            if ([cards isStraight]) {
                return Straight;
            }
            else if ([cards isMoreDouble]) {
                return MoreDouble;
            }
            else if ([cards isFourAndTwoDouble]) {
                return FourAndTwoDouble;
            }
            else if ([cards isPlaneAndOne]) {
                return PlaneAndOne;
            }
            else if ([cards isPlaneAndDouble]) {
                return PlaneAndDouble;
            }
            return 0;
    }
    return 0;
}

@end
