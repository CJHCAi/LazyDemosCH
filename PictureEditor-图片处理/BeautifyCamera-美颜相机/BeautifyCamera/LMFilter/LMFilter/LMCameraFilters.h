//
//  LMCameraFilters.h
//  GPUImageDemo
//
//  Created by xx11dragon on 15/9/22.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "GPUImage.h"
#import "LMFilterGroup.h"

@interface LMCameraFilters : NSObject

//    正常
+ (LMFilterGroup *)normal;

+ (LMFilterGroup *)saturation;

+ (LMFilterGroup *)exposure;

+ (LMFilterGroup *)contrast;

+ (LMFilterGroup *)testGroup1;

+ (LMFilterGroup *)beautyGroup;

@end
