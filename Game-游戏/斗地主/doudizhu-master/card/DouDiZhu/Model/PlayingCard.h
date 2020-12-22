//
//  PlayingCard.h
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

/*! @brief 花色 @"♠︎", @"♥︎", @"♣︎", @"♦︎". */
@property (nonatomic, strong) NSString *suit;

/*! @brief 牌的大小 3,4,5,6,7,8,9,10,J,Q,K,A,2. */
@property (nonatomic, assign) NSUInteger rank;

/**
 *  所有的花色 @"♠︎", @"♥︎", @"♣︎", @"♦︎"
 *
 *  @return 花色数组
 */
+ (NSArray *)validSuits;

/**
 *  最大牌值
 *
 *  @return 牌值
 */
+ (NSUInteger)maxRank;

/**
 *  比大小
 *
 *  @param card 比较对象
 *
 *  @return 是否比card大
 */
- (BOOL)biggerThan:(PlayingCard *)card;

@end
