//
//  SXTThirdLoginView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^qqLandingMethodBlock)();

@interface SXTThirdLoginView : UIView

@property (copy, nonatomic) qqLandingMethodBlock qqBlock;

@end
