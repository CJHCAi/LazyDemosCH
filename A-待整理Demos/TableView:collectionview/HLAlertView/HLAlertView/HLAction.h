//
//  HLAction.h
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLAction : UIButton

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,strong) HLActionModel *model;
+ (instancetype)actionWithTitle:(NSString *)title handler:(void(^ __nullable)(HLAction *action))handler;
@end

NS_ASSUME_NONNULL_END
