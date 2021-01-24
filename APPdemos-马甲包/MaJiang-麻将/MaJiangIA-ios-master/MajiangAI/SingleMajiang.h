//
//  SingleMajiang.h
//  MajiangAI
//
//  Created by papaya on 16/4/28.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConstantClass.h"

typedef NS_ENUM(NSInteger , MajiangType)
{
    Wan_1 = 1,  //万
    Wan_2 = 2,
    Wan_3 = 3,
    Wan_4 = 4,
    Wan_5 = 5,
    Wan_6 = 6,
    Wan_7 = 7,
    Wan_8 = 8,
    Wan_9 = 9,
    
    Tiao_1 = 21,   //条
    Tiao_2 = 22,
    Tiao_3 = 23,
    Tiao_4 = 24,
    Tiao_5 = 25,
    Tiao_6 = 26,
    Tiao_7 = 27,
    Tiao_8 = 28,
    Tiao_9 = 29,
    
    Tong_1 = 41,   //筒子
    Tong_2 = 42,
    Tong_3 = 43,
    Tong_4 = 44,
    Tong_5 = 45,
    Tong_6 = 46,
    Tong_7 = 47,
    Tong_8 = 48,
    Tong_9 = 49,
    
    Hua_1 = 61,   //东风
    Hua_2 = 71,   //南风
    Hua_3 = 81,   //西风
    Hua_4 = 91,   //北风
    Hua_5 = 101,  //中
    Hua_6 = 111,  //白板
    Hua_7 = 121   //发财
    
};

typedef NS_ENUM(NSInteger, MajiangStatus)
{
    Pile             = -1,   //牌堆里
    PileUpAndDown    = 0,    //上下方向的牌堆里
    PileLeftAndRight = 1,    //左右方向的牌堆里
    RrightHave       = 2,    //右边的人拥有
    UpHave           = 3,    //上边的人拥有
    LeftHave         = 4,    //左边的人拥有
    MeHave           = 5,    //我拥有
    RightPut         = 6,    //右边的人打出
    UpPut            = 7,    //上边的人打出
    LeftPut          = 8,    //左边的人打出
    MePut            = 9     //我打出
    
};


@interface SingleMajiang : NSObject

/**
 *  麻将块的当前状态
 */
@property (nonatomic) MajiangStatus status;

/**
 *  麻将的类型，也就是麻将的花色
 */
@property (nonatomic) MajiangType type;

- (void)settingMJWithType:(MajiangType)tye status:(MajiangStatus)status;

@end
