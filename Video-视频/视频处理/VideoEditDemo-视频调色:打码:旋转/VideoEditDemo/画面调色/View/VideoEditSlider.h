//
//  VideoEditSlider.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/20.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VideoEditEnum)
{
    /** 亮度 */
    VideoEditLight = 1112,
    
    /** 对比度 */
    VideoEditContrast = 1113,
    
    /** 饱和度 */
    VideoEditSaturation = 1114,
    
    /** 色温 */
    VideoEditColorTemperature = 1115,
    
    /** 锐度 */
    VideoEditSharpness = 1116,
    
    /** 暗角 */
    VideoEditDrak = 1117
    
};


@interface VideoEditSlider : UISlider

@property (readwrite,nonatomic)VideoEditEnum videoEditEnum;


@end
