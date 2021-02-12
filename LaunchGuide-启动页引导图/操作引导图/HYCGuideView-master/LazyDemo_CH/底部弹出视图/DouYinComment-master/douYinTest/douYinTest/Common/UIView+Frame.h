//
//  UIView+Frame.h
//  TIBeauty_IPhone
//
//  Created by ws ou on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) CGPoint origin;

@property(nonatomic,readonly) CGFloat left;
@property(nonatomic,readonly) CGFloat top;
@property(nonatomic,readonly) CGFloat right;
@property(nonatomic,readonly) CGFloat bottom;

@end
