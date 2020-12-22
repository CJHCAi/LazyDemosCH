//
//  Deck.h
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

/**
 *  添加一个纸牌到牌堆
 *
 *  @param card 纸牌
 */
- (void)addCard:(Card *)card;

/**
 *  随机获得一个纸牌（并从牌堆中删除这张）
 *
 *  @return 纸牌
 */
- (Card *)getRandomCard;

/**
 *  获取牌堆总数
 *
 *  @return 总数
 */
- (NSInteger)getCardTotals;

@end
