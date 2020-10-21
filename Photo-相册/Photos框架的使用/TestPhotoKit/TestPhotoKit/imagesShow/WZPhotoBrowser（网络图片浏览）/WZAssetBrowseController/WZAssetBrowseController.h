//
//  WZAssetBrowseController.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageBrowseController.h"


@interface WZAssetBrowseController : WZImageBrowseController

@property (nonatomic, assign) PHImageRequestID imageRequestID;//请求图片的请求ID
@property (nonatomic, assign) PHImageRequestID imageDataRequestID;//请求图片(data)的请求ID

/**
 *  用于判断滑动的图片是否越界
 *
 *  @return 是否越界
 */
- (BOOL)overloadJudgement;

/**
 *  用于计算当前选中的图片数目的接口
 */
- (void)caculateSelected;

@end
