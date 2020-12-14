//
//  FailedView.h
//  SportChina
//
//  Created by 栗子 on 2017/7/13.
//  Copyright © 2017年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedView : UIView

-(instancetype)initCustomFailedTitle:(NSString *)text contentStr:(NSString *)content andTop:(float)top Alpha:(float)alpha;
/**显示*/
- (void)show:(BOOL)animated;
/**隐藏*/
- (void)hide:(BOOL)animated;



/*引用
 FailedView *failed=[[FailedView alloc]initCustomFailedTitle:@"糟糕!打卡失败啦" contentStr:@"攻略:你可以再靠近点哦"];
 [failed show:YES];
 
 */


@end
