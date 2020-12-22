//
//  User.m
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, readwrite) NSMutableArray *myCards;
@property (nonatomic, readwrite, getter=isLandlord) BOOL landlord;

@end

@implementation User

- (NSMutableArray *)myCards
{
    if (!_myCards) {
        _myCards = [NSMutableArray new];
    }
    return _myCards;
}

#pragma mark 初始化
- (void)setCarsCount:(NSInteger)count usingDeck:(PlayingDeck *)deck
{
    _myCards = nil;
    // 拿13张牌
    for (int i = 0; i < count; i ++) {
        Card *card = [deck getRandomCard];
        self.myCards[i] = card;
    }
    self.myCards = [[self.myCards sortCards] mutableCopy];
}

- (BOOL)outCards:(NSArray *)cards lastOut:(NSArray *)lastCards
{
    BOOL canOut = YES;
    OutCardsType cardsType = [GameTable judgeOutCardsTypeFor:cards];
    OutCardsType lastCardsType = [GameTable judgeOutCardsTypeFor:lastCards];
    
    // ************************ 王炸
    // 王炸直接出
    if (cardsType == KingBomb) {
        return canOut;
    }
    // 别人王炸直接不能出
    if (lastCardsType == KingBomb) {
        return !canOut;
    }
    
    // ************************ 炸弹
    if (cardsType == Bomb) {
        // 判断上次是否是炸弹
        if (lastCardsType == Bomb) {
            // 炸弹判断大小
            return [cards.firstObject biggerThan:lastCards.firstObject];
        }
        else {
            return canOut;
        }
    }
    
    // ************************ 其他
    OutCardsOtherType cardsOtherType = [GameTable judgeOutCardsOtherTypeFor:cards];
    OutCardsOtherType lastCardsOtherType = [GameTable judgeOutCardsOtherTypeFor:lastCards];
    
    // *********** 能不能出
    if (!cardsOtherType) {
        // 当前牌不能出
        return !canOut;
    }
    if (!lastCardsOtherType) {
        // 上次牌没类型当前牌直接出
        return canOut;
    }
    
    // *********** 类型不一样
    if (cardsOtherType != lastCardsOtherType) {
        return !canOut;
    }
    
    // *********** 类型一样，比大小  三带一 三带二 四带二 飞机除外
    if (cardsOtherType == ThreeAndOne || cardsOtherType == ThreeAndDouble || cardsOtherType == FourAndTwo || cardsOtherType == FourAndTwoDouble || cardsOtherType == PlaneAndOne || cardsOtherType == PlaneAndDouble) {
        return [[cards findSmallForMoreCards] biggerThan:[lastCards findSmallForMoreCards]];
    }
    return [cards.firstObject biggerThan:lastCards.firstObject];
}

- (void)setLandlordWithOtherCards:(NSArray *)otherCards
{
    [self.myCards addObjectsFromArray:otherCards];
    _landlord = true;
}

- (void)thinkingGrabLandlord
{
    
}

- (void)thinkingOutCards:(NSArray *)lastOutCards
{
    
}

@end
