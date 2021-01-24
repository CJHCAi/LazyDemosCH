//
//  UnPutMJHeap.h
//  MajiangAI
//
//  Created by papaya on 16/4/28.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleMajiang.h"

@interface UnPutMJHeap : NSObject


- (void)Shuffle;
- (SingleMajiang *)objectAtIndex:(NSInteger)index;
- (NSInteger)count;

@end
