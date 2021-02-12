//
//  CMenuConfig.h
//  ClassifyMenuDemo
//
//  Created by LiuLi on 2019/2/21.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Masonry.h"
#define SCREEN_W  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height
#define Rate UIScreen.mainScreen.bounds.size.width/375   //屏宽比例
#define IphoneX  (([UIScreen mainScreen].bounds.size.width==375&&[UIScreen mainScreen].bounds.size.height==812))
#define kNavHeight (IphoneX==YES ? 88 : 64)
#define TabBarH (IphoneX==YES ? 83 : 49)

NS_ASSUME_NONNULL_BEGIN

@interface CMenuConfig : NSObject

@end

NS_ASSUME_NONNULL_END
