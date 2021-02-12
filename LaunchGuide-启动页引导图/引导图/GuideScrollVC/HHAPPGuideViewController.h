//
//  HHAPPGuideViewController.h
//  RuiYiEducation
//
//  Created by 火虎MacBook on 2020/8/6.
//  Copyright © 2020 ruizhixue. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define APPGuideFirstShowKey @"APPGuideFirstShowKey"

@interface HHAPPGuideViewController : UIViewController
-(instancetype)initwithGuideImages:(NSArray<NSString *> *)guideImages showPageControl:(BOOL)isShowisShowPageDot rootViewControler:(UIViewController *)rootVC;
@end

NS_ASSUME_NONNULL_END
