//
//  UIView+oc_size.h
//  Pods-s_ios_categories_Example
//
//  Created by hs on 2018/6/20.
//

#import <UIKit/UIKit.h>

@interface UIView (oc_size)

// frame accessors

@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

// bounds accessors

@property (assign, nonatomic) CGSize boundsSize;
@property (assign, nonatomic) CGFloat boundsWidth;
@property (assign, nonatomic) CGFloat boundsHeight;

// content getters

@property (readonly, nonatomic) CGRect contentBounds;
@property (readonly, nonatomic) CGPoint contentCenter;

@end
