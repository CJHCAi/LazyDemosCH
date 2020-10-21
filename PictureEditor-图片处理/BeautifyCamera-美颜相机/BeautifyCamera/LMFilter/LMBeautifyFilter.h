//
//  LMBeautifyFilter.h
//  BeautifyCamera
//
//  Created by sky on 2017/1/17.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "LMFilter/LMFilterGroup.h"

@class GPUImageCombinationFilter;
@interface LMBeautifyFilter : LMFilterGroup{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end
