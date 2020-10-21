//
//  UIView+ViewDesc.h
//  AVPlayerViewControllerTest
//
//  Created by tanzhiwu on 2018/12/29.
//  Copyright © 2018 tanzhiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewDesc)
- (UIView *)findViewByClassName:(NSString *)className;
- (BOOL)isHairScreen;
@end

NS_ASSUME_NONNULL_END
