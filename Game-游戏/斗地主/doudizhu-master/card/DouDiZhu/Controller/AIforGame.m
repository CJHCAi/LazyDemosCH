//
//  AIforGame.m
//  card
//
//  Created by tmachc on 15/9/11.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AIforGame.h"

@interface AIforGame ()

@end

@implementation AIforGame

- (void)thinkingGrabLandlord
{
    [self.delegete grabLandlord:YES withTag:self.tag];
}

- (void)thinkingOutCards:(NSArray *)lastOutCards
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 延迟3秒出牌
//    [NSThread sleepForTimeInterval:3];
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (lastOutCards.count == 1) {
                for (int i = 0; i < self.myCards.count; i ++) {
                    if ([self.myCards[i] biggerThan:lastOutCards.firstObject]) {
                        if ([self outCards:@[self.myCards[i]] lastOut:lastOutCards]) {
                            NSLog(@"computer%d 出的是 ： \n%@",(int)self.tag, ((PlayingCard *)self.myCards[i]).contents);
                            PlayingCard *card = self.myCards[i];
                            [self.myCards removeObjectAtIndex:i];
                            [self.delegete outCards:@[card] withTag:self.tag];
                            return;
                        }
                    }
                }
            }
            else {
                if ([self outCards:@[self.myCards.firstObject] lastOut:lastOutCards]) {
                    NSLog(@"computer%d 出的是 ： \n%@",(int)self.tag, ((PlayingCard *)self.myCards.firstObject).contents);
                    PlayingCard *card = self.myCards.firstObject;
                    [self.myCards removeObjectAtIndex:0];
                    [self.delegete outCards:@[card] withTag:self.tag];
                    return;
                }
            }
            
            NSLog(@"computer%d 不要",(int)self.tag);
            // 默认不出
            [self.delegete outCards:@[] withTag:self.tag];
        });
    });
}

@end
