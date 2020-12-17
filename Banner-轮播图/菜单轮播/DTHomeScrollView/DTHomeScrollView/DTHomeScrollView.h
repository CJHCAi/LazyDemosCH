//
//  DTHomeScrollView.h
//  DTcollege
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ZDQK. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class DTHomeScrollView;
@protocol DTHomeScrollViewDelegate <NSObject>

/**
 clickButtonWithView

 @param btn clickBtn
 @param index ClickWithIndex
 @param view DTHomeScrollView
 */
- (void)buttonUpInsideWithView:(UIButton *)btn
                     withIndex:(NSInteger)index
                      withView:(DTHomeScrollView *)view;
@end;

@interface DTHomeScrollView : UIView

/**
 maxCount is view count, default is 6
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 delegate is button click
 */
@property (nonatomic, weak) id<DTHomeScrollViewDelegate> delegate;

#pragma mark - Initializers

/**
 Initialize with Frame and Views.

 @param frame t
 @param views the Views is Buttons
 @return DTHomeScrollView
 */
- (instancetype)initWithFrame:(CGRect)frame
                  viewsArray:(NSArray *)views;
@end
NS_ASSUME_NONNULL_END
