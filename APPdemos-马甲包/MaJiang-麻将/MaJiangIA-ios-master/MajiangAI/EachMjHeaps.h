//
//  EachMjHeaps.h
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "singleMajiangNode.h"

#define SelfWidth 40
#define SelfHeight [UIScreen mainScreen].bounds.size.height / 2

typedef NS_ENUM(NSInteger, EachMjHeapsType)
{
    Down = 0,
    Right = 1,
    Up = 2,
    Left = 3
};

@interface EachMjHeaps : SKSpriteNode


- (void)settingWith:(EachMjHeapsType)type length:(CGFloat)length centerPoint:(CGPoint)centerPoint;

- (void)settingMjHeaps:(NSMutableArray *)mjHeaps;

@end
