//
//  ZCSHoldProgress.h
//  ZCSHoldProgessDemo
//
//  Created by Zane Shannon on 9/3/14.
//  Copyright (c) 2014 Zane Shannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCSHoldProgress;

@protocol ZCSHoldProgressDelegate <NSObject>

- (void)videoStopTimeEventWhenTouch:(ZCSHoldProgress *)progress;
- (void)videoBeginTimeEventWhenLeave:(ZCSHoldProgress *)progress;

@end

@interface ZCSHoldProgress : UILongPressGestureRecognizer

@property (nonatomic) NSTimeInterval displayDelay;
@property (nonatomic) float alpha;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *completedColor;
@property (nonatomic) float borderSize;
@property (nonatomic) float size;
@property (nonatomic) float minimumSize;
@property (nonatomic) BOOL hideOnComplete;
@property (nonatomic) CGRect rectView;

@property (nonatomic, weak) id<ZCSHoldProgressDelegate> delegateProcess;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
