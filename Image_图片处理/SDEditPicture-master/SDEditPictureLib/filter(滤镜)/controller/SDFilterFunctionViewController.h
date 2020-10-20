//
//  SDFilterFunctionViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDiyBaseFunctionViewController.h"
@class IFImageFilter;
@interface SDFilterFunctionViewController : SDDiyBaseFunctionViewController





/**
 选择了一个渲染，通知viewController来改变显示的图片

 @param imageFilter 渲染模块
 */
- (void)changeImageFilter:(IFImageFilter * )imageFilter;


/**
 显示原始图片
 */
- (void)showOriginImageFilter;





@end
