//
//  HXPhotoPersentInteractiveTransition.h
//  照片选择器
//
//  Created by 洪欣 on 2018/9/8.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXPhotoView;
@interface HXPhotoPersentInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interation;
@property (assign, nonatomic) BOOL atFirstPan;
- (void)addPanGestureForViewController:(UIViewController *)viewController photoView:(HXPhotoView *)photoView ;
@end
