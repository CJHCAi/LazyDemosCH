//
//  YXWBigAlpView.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/13.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFZ_didAction.h"
@interface YXWBigAlpView : UIView

@property (nonatomic, strong) ZFZ_didAction *didView;
@property (nonatomic, copy) void (^blockRemove)();

@end
