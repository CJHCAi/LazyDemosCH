//
//  FXSingleRowItemsManager.h
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/5.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXDanmakuItem.h"

@interface FXSingleRowItemsManager : NSObject

- (FXDanmakuItem *)itemAtPoint:(CGPoint)point;

- (void)addDanmakuItem:(FXDanmakuItem *)item;
- (void)removeDanmakuItem:(FXDanmakuItem *)item;

@end
