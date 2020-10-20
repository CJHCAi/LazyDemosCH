//
//  SXTNextLandingView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^landingBtnBlock)(NSString *code);

@interface SXTNextLandingView : UIView
@property (copy, nonatomic) landingBtnBlock landingBlock;//注册按钮回调block
@property (copy, nonatomic) NSString *phoneNumString;//记录手机号
- (void)GCDTime;
@end
