//
//  StatusTipView.h
//  italker
//
//  Created by XuxingGuo on 14/10/23.
//  Copyright (c) 2014年 verywill. All rights reserved.
//

#import <UIKit/UIKit.h>

enum StatusTipStatus{
    StatusTipBusy,
    StatusTipSuccess,
    StatusTipFailure
};

@interface StatusTipView : UIView

+ (void) setHoldingScreen:(BOOL) hold;

+ (void) showStatusTip:(NSString *)tip status:(enum StatusTipStatus)status;
+ (void) hideStatusTipDelay:(NSTimeInterval)delay;
+ (void) hideStatusTipDelay:(NSTimeInterval)delay animate:(BOOL)animate;

@end
