//
//  LMHahaFilters.h
//  BeautifyCamera
//
//  Created by sky on 2017/2/14.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "GPUImage.h"
#import "LMFilterGroup.h"

@interface LMHahaFilters : LMFilterGroup

+(LMFilterGroup *)  vignetteGroup;
+(LMFilterGroup *)  swirlGroup;
+(LMFilterGroup *)  bulgeDistortionGroup;
+(LMFilterGroup *)  pinchDistortionGroup;
+(LMFilterGroup *)  stretchDistortionGroup;
+(LMFilterGroup *)  glassSphereGroup;
+(LMFilterGroup *)  sphereRefractionGroup;

@end
