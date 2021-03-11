//
//  HLButton.h
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/8.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLButton : NSObject
@property (nonatomic ,copy) NSString *title;
+ (instancetype)buttonWithTitle:(NSString *)title block:(void(^)(Constraint *constraint,HLButtonModel *buttonModel))block handler:(void(^ __nullable)(HLButton *action))handler;

@end

NS_ASSUME_NONNULL_END
