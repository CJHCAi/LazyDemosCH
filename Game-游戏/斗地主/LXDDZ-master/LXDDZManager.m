//
//  LXDDZManager.m
//  JokeApp
//
//  Created by longxin.sui on 2018/4/13.
//  Copyright © 2018年 slx. All rights reserved.
//

#import "LXDDZManager.h"

@interface LXDDZManager()
// 花色
@property(nonatomic, copy)NSArray *colorArray;
// 牌号
@property(nonatomic, copy)NSArray *numArray;
// 扑克数组
@property(nonatomic, strong)NSMutableArray *alllPokerArray;
@end

@implementation LXDDZManager

- (instancetype)init {
    self = [super init];
    if(self) {
        // 扑克牌初始化
        self.alllPokerArray = [NSMutableArray arrayWithArray:@[@"=大王=", @"-小王-"]];
        for (NSString *num in self.numArray) {
            for (NSString *color in self.colorArray) {
                [self.alllPokerArray addObject:[color stringByAppendingString:num]];
            }
        }
    }
    NSLog(@"All Poker Init: %@", self.alllPokerArray);
    
    return self;
}

- (NSArray *)mixPokerOrder {
    return [self.alllPokerArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int seed = arc4random_uniform(2);
        if(seed) {
            return [obj1 compare:obj2];
        }else {
            return [obj2 compare:obj1];
        }
    }];
}

- (void)setPokerForUserIndex:(int)index withPokerArray:(NSArray *)pokerArray {
    if(index > 3) {
        // 地主的底牌
        NSRange range = NSMakeRange(17*(index - 1), 3);
        NSArray *lastPokerArray = [pokerArray subarrayWithRange:range];
        NSLog(@"Last 3 Poker: %@", lastPokerArray);
    }else {
        // 分牌
        NSRange range = NSMakeRange(17*(index - 1), 17);
        NSArray *userPokerArray = [pokerArray subarrayWithRange:range];
        // 匹配牌号，生成正序数组
        NSMutableArray *orderArray = [self.alllPokerArray mutableCopy];
        for (NSString *poker in self.alllPokerArray) {
            if(![userPokerArray containsObject:poker])
                [orderArray removeObject:poker];
        }
        NSLog(@"User%d Poker: %@", index, orderArray);
        // 继续发牌
        [self setPokerForUserIndex:++index withPokerArray:pokerArray];
    }
}

#pragma mark - Public

- (void)startGame {
    NSLog(@"Game Start...");
    // 打乱扑克牌顺序
    NSArray *mixPoker = [self mixPokerOrder];
    // 开始分牌
    [self setPokerForUserIndex:1 withPokerArray:mixPoker];
}



#pragma mark - GET/SET

- (NSArray *)colorArray {
    if(_colorArray == nil) {
        _colorArray = @[@"黑桃", @"红心", @"梅花", @"方片"];
    }
    
    return _colorArray;
}

- (NSArray *)numArray {
    if (_numArray == nil) {
        _numArray = @[@"2", @"A", @"K", @"Q", @"J", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3"];
    }
    
    return _numArray;
}

@end
