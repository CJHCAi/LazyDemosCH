//
//  HMLabel.h
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/9.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMLabel : NSObject
@property (nonatomic,copy, readonly)NSString *title;
+ (instancetype)labelWithTitle:(NSString *)title block:(void(^)(Constraint *constraint,HLTextModel *textModel))block;
@end

NS_ASSUME_NONNULL_END
