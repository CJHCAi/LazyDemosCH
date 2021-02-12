//
//  MajiangEachHeaps.h
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleMajiang.h"
#import "singleMajiangNode.h"

@interface MajiangEachHeaps : NSObject

- (void)settingWithArray:(NSMutableArray *)mjHeap direction:(MajiangStatus)status;

- (NSInteger)cout;

- (SingleMajiang *)objectAtIndex:(NSInteger)index;

@end
