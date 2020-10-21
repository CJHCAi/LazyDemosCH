//
//  HSImageSidebarView.h
//  Sidebar
//
//  Created by BJ Homer on 11/16/10.
//  Copyright 2010 BJ Homer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSImageSidebarViewDelegate.h"


@interface HSImageSidebarView : UIView {
}

@property (readonly) NSUInteger imageCount;
@property (strong, readonly) NSIndexSet *visibleIndices;
@property (strong) NSMutableArray *imageViews;
@property (weak) id<HSImageSidebarViewDelegate> delegate;
@property (assign) CGFloat rowHeight;
@property (assign) NSInteger selectedIndex;
@property (strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIVisualEffectView *tF;
@property (nonatomic, strong) UIView *lineAdjuster;
@property (nonatomic, strong) UIView *invisiView;
@property (nonatomic, strong) UIView *fullView;
@property (nonatomic, strong) UIImageView *dot1;
@property (nonatomic, strong) UIImageView *dot2;
@property (nonatomic, strong) NSMutableArray *backgroundFrames;
@property (nonatomic, strong) NSMutableArray *imageOffsets;
@property CGFloat offSet1;
@property CGFloat offSet2;
@property CGFloat offSet3;
@property CGFloat offSet4;
@property CGFloat offSet5;
@property CGFloat offSet6;
@property CGFloat offSet7;
@property CGFloat offSet8;
@property CGFloat offSet9;
@property CGFloat offSet10;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property bool hasLoadedOnce;
@property bool isSmall;


- (CGRect)frameOfImageAtIndex:(NSUInteger)anIndex;

- (BOOL)imageAtIndexIsVisible:(NSUInteger)anIndex;
- (void)scrollRowAtIndexToVisible:(NSUInteger)anIndex;

- (void)insertRowAtIndex:(NSUInteger)anIndex;
- (void)deleteRowAtIndex:(NSUInteger)anIndex;
- (void)reloadData;
-(void)dismissAdjuster;
-(void)increaseTime;
-(void)shrinkThis;
-(void)decreaseTime;

@end
