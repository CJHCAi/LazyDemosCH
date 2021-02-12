//
//  MajiangEachHeaps.m
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "MajiangEachHeaps.h"


@interface MajiangEachHeaps()

@property (nonatomic) NSMutableArray *majiangNodes;


@end

@implementation MajiangEachHeaps

- (void)settingWithArray:(NSMutableArray *)mjHeap direction:(MajiangStatus)status
{
    _majiangNodes = [NSMutableArray array];
    for ( int i = 0; i < [mjHeap count]; ++i ){
        SingleMajiang *mj = [mjHeap objectAtIndex:i];
        mj.status = status;
        singleMajiangNode *mjNode = [[singleMajiangNode alloc] init];
        [mjNode settingWithMj:mj];
        [_majiangNodes addObject:mjNode];
    }
}

@end
