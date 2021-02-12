//
//  UIView+Sunshine.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Sunshine)
@property (nonatomic, strong)NSArray *sunshineViews;

- (void)beginSunshineAnimation;
- (void)endSunshineAnimation;

@end

NS_ASSUME_NONNULL_END
