//
//  HLLabel.h
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLLabel : NSObject

+ (instancetype)labelWithTitle:(NSString *)title block:(void(^)(Constraint *constraint,HLLabelModel *labelModel))block;

- (void)hide:(BOOL)state;
@end

NS_ASSUME_NONNULL_END
