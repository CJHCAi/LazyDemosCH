//
//  GLHGuideView.h
//  GLHGuideView
//
//  Created by ligui on 2017/5/26.
//  Copyright © 2017年 ligui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLHGuideView : UIView
/*!
 *  初始化引导页面
 *
 *  @param frame  引导页面的 frame
 *  @param guides <@"引导描述" : 点击范围>
 *
 *  @return 引导页面
 */
- (GLHGuideView *)initWithFrame:(CGRect)frame
                         guides:(NSArray<NSDictionary<NSString *,NSValue *> *> *)guides styles:(NSArray *)styleArr arrowType:(NSArray *)arrowTypeArr;

/*!
 *  开始引导
 */
- (void)showGuide;

@end
