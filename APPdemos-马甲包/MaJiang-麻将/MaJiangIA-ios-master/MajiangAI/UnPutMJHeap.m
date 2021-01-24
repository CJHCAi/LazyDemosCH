//
//  UnPutMJHeap.m
//  MajiangAI
//
//  Created by papaya on 16/4/28.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "UnPutMJHeap.h"

@interface UnPutMJHeap()

@property (nonatomic) NSMutableArray *mjHeaps;

@end

@implementation UnPutMJHeap

- (void)Shuffle{
    NSMutableArray *mjHeaps = [NSMutableArray array];
    [self putAllMjInHeaps:mjHeaps];
    
    _mjHeaps = [NSMutableArray array];
    //[self randomMjHeapsWithMjHeaps:mjHeaps];
    _mjHeaps = [NSMutableArray arrayWithArray:mjHeaps];
//    for  ( int i = 0; i < _mjHeaps.count; ++i ){
//        SingleMajiang *mj = [_mjHeaps objectAtIndex:i];
//        NSLog(@"%d %d",(int)mj.type,(int)mj.status);
//    }
//    NSLog(@"count : %d ",(int)_mjHeaps.count);
}


//递归完成随机洗牌
- (void)randomMjHeapsWithMjHeaps:(NSMutableArray *)mjHeaps{
    
    if ( mjHeaps.count == 0 ) return;
    
    NSInteger randomIdenx = (NSInteger)arc4random() % mjHeaps.count;
    
    SingleMajiang *mj = [mjHeaps objectAtIndex:randomIdenx];
    [_mjHeaps addObject:mj];
    [mjHeaps removeObjectAtIndex:randomIdenx];
    [self randomMjHeapsWithMjHeaps:mjHeaps];
    
}

//把所有的排放入牌堆中
- (void)putAllMjInHeaps:(NSMutableArray *)mjHeaps{
    
    //每种牌有4个
    for ( int num = 0; num < 4; ++ num ){
        //放万
        for ( int i = 1; i <= 9; ++i ){
            SingleMajiang *mj = [[SingleMajiang alloc] init];
            [mj settingMJWithType:i status:Pile];
            [mjHeaps addObject:mj];
        }
        
        //放万
        for ( int i = 1; i <= 9; ++i ){
            SingleMajiang *mj = [[SingleMajiang alloc] init];
            [mj settingMJWithType:i+20 status:Pile];
            [mjHeaps addObject:mj];
        }
        
        //放筒子
        for ( int i = 1; i <= 9; ++i ){
            SingleMajiang *mj = [[SingleMajiang alloc] init];
            [mj settingMJWithType:i+40 status:Pile];
            [mjHeaps addObject:mj];
        }
        
        for ( int i = 0; i < 7; ++i ){
            SingleMajiang *mj = [[SingleMajiang alloc] init];
            [mj settingMJWithType:i*10+61 status:Pile];
            [mjHeaps addObject:mj];
        }
    }
}



- (NSInteger)count
{
    return _mjHeaps.count;
}

- (SingleMajiang *)objectAtIndex:(NSInteger)index
{
    return _mjHeaps[index];
}

@end
