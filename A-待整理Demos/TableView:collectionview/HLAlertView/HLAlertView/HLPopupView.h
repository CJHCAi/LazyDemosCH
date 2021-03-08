//
//  HLPopupView.h
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/1.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class HLAlertView;
@interface HLPopupView : UIView
- (CGFloat)getCurrentHeight;
- (void)fixSize:(CGSize)size;
- (void)addItemToArrayWithObject:(id)object;


@end

NS_ASSUME_NONNULL_END
