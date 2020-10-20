//
//  GPUImageBeautyFilter.h
//  美颜
//
//  Created by apple on 2017/4/10.
//  Copyright © 2017年 yangchao. All rights reserved.
//
#import "GPUImageFilter.h"
#import "GPUImage.h"
@interface GPUImageBeautyFilter : GPUImageFilter

/** 美颜程度 */
@property (nonatomic, assign) CGFloat beautyLevel;
/** 美白程度 */
@property (nonatomic, assign) CGFloat brightLevel;
/** 色调强度 */
@property (nonatomic, assign) CGFloat toneLevel;

@end
