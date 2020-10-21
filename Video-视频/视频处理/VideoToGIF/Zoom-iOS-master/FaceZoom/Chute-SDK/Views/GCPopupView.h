//
//  GCPopupView2.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPopupView : UIView {
    UIView *contentView;
    UIButton *closeButton;
}

+ (void)show;
+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view fromStartPoint:(CGPoint)startPoint;

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView;
- (void)layoutSubviews;
+ (CGRect)popupFrameForView:(UIView *)_view withStartPoint:(CGPoint)_startPoint;

- (void)showPopupWithCompletition:(void (^)(void))completition;
- (void)closePopup;
- (void)closePopupWithCompletition:(void (^)(void))completition;

@end
