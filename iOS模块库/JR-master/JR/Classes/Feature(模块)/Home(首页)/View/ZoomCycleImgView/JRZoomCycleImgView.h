//
//  LTZoomCycleImgView.h
//  旅途逸居
//
//  Created by 张骏 on 17/5/5.
//  Copyright © 2017年 武汉国扬科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRZoomCycleImgView : UIView

/**
 图片广告
 */
@property (nonatomic, strong) NSArray *picArray;

/**
 回调
 */
@property (nonatomic, copy) returnBlock clicked;

@end
