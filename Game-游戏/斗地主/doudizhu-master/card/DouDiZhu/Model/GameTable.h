//
//  GameTable.h
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef NS_ENUM(NSInteger, OutCardsType) {
    KingBomb = 3,
    Bomb = 2,
    Other = 1
};

// 单牌，对，三个，三带一，三带对，四带二，顺子5个起，连对3个起，飞机，飞机带一，飞机带对
typedef NS_ENUM(NSInteger, OutCardsOtherType) {
    Single = 1,         // 1
    Double,             // 2
    Three,              // 3
    ThreeAndOne,        // 4
    ThreeAndDouble,     // 5
    Plane,              // 6
    PlaneAndOne,        // 7
    PlaneAndDouble,     // 8
    FourAndTwo,         // 9
    FourAndTwoDouble,   // 10
    Straight,           // 11 顺子5个起
    MoreDouble          // 12 连对3个起
};

@interface NSObject (GameTable)

- (BOOL)isEqualCard:(id)object;

@end

@interface NSArray (GameTable)

- (NSArray *)sortCards;
- (PlayingCard *)findSmallForMoreCards;

@end

@interface GameTable : NSObject

/**
 *  判断牌是否是 炸
 *
 *  @param cards 牌
 *
 *  @return 王炸、炸弹、其他
 */
+ (OutCardsType)judgeOutCardsTypeFor:(NSArray *)cards;

/**
 *  判断牌的其他类型
 *
 *  @param cards 牌
 *
 *  @return  单牌，对，三个，三带一，三带对，四带二，顺子5个起，连对3个起，飞机，飞机带一，飞机带对
 */
+ (OutCardsOtherType)judgeOutCardsOtherTypeFor:(NSArray *)cards;

@end
