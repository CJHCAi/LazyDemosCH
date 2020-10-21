//
//  HXPhotoInteractiveTransition.h
//  照片选择器
//
//  Created by 洪欣 on 2017/10/28.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXPhotoInteractiveTransition : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
@property (assign, nonatomic) BOOL atFirstPan;
- (void)addPanGestureForViewController:(UIViewController *)viewController; 
@end
