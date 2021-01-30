//
//  WDCircleAnimationView.h
//  CircleAnimationUserInteractionDemo
//
//  Created by Amale on 16/2/29.
//  Copyright © 2016年 Amale. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FunctionType) {
    FunctionTypeAuto,   //模式为自动
    FunctionTypeSnow,   //模式为制冷
    FunctionTypeSun,    //模式为暖气
    FunctionTypeWind,   //模式为送风
    FunctionTypeChuShi, //模式为除湿
};

@interface WDCircleAnimationView : UIView

@property (nonatomic, assign) FunctionType functionImage; // 功能类型

@property(nonatomic,assign) NSInteger temperInter ;   //温度(18 - 30)

@property (nonatomic, copy) NSString *text;       // 中间区域显示的文字

@end
