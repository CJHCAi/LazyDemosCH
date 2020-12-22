//
//  User.h
//  card
//
//  Created by tmachc on 15/9/9.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingDeck.h"
#import "PlayingCard.h"
#import "GameTable.h"

@protocol EndThinkingDelegate <NSObject>

- (void)grabLandlord:(BOOL)isGrab withTag:(NSInteger)tag;
- (void)outCards:(NSArray *)cards withTag:(NSInteger)tag;

@end

@interface User : NSObject

@property (nonatomic, readonly) NSMutableArray *myCards;
@property (nonatomic, readonly, getter=isLandlord) BOOL landlord;
@property (nonatomic, getter=isTurn) BOOL turn;
@property (nonatomic, assign) NSInteger tag;
@property (weak) id<EndThinkingDelegate> delegete;

- (void)setCarsCount:(NSInteger)count usingDeck:(PlayingDeck *)deck;

/**
 *  出牌
 *
 *  @param cards 所出的牌
 *
 *  @return 是否可以出
 */
- (BOOL)outCards:(NSArray *)cards lastOut:(NSArray *)lastCards;

- (void)setLandlordWithOtherCards:(NSArray *)otherCards;

- (void)thinkingGrabLandlord;

- (void)thinkingOutCards:(NSArray *)lastOutCards;

@end
