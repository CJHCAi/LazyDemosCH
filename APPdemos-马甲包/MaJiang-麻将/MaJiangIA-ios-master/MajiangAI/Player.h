//
//  Player.h
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "singleMajiangNode.h"


@protocol PlayerDelegate <NSObject>

@optional

//告诉裁判需要碰牌
- (void)NeedBump;

- (void)playOneMj:(SingleMajiang *)mj;

@end

typedef NS_ENUM(NSInteger, PlayerStatus)
{
    WaitStatus = 0,            //等待别的玩家
    InterceptStatus = 1,       //拦截状态，碰，吃，杠，不揭牌，只出牌
    DrawStatus = 2             //轮到自己揭牌，出牌
};

@interface Player : NSObject

/**
 *  手牌
 */
@property (nonatomic) NSMutableArray *handMjs;

@property (nonatomic) BOOL isSuccess;

@property (nonatomic) PlayerStatus status;

@property (nonatomic) id<PlayerDelegate> delegate;


- (void)addOneMj:(singleMajiangNode *)mj;

@end
