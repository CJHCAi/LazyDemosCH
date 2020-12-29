//  Created by Rafael Kayumov (RealPoc).
//  Copyright (c) 2013 Rafael Kayumov. License: MIT.

#import <UIKit/UIKit.h>
#import "RKTabItem.h"

typedef struct HorizontalEdgeInsets {
    CGFloat left, right;
} HorizontalEdgeInsets;

static inline HorizontalEdgeInsets HorizontalEdgeInsetsMake (CGFloat left, CGFloat right) {
    HorizontalEdgeInsets insets = {left, right};
    return insets;
}

@class RKTabItem;
@class RKTabView;

@protocol RKTabViewDelegate <NSObject>

@optional
//Called for all types except TabTypeButton
- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSInteger)index tab:(RKTabItem *)tabItem;
//Called Only for unexcludable items. (TabTypeUnexcludable)
- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSInteger)index tab:(RKTabItem *)tabItem;

@end

@interface RKTabView : UIView

@property (nonatomic, assign) IBOutlet id<RKTabViewDelegate> delegate;
@property (readwrite) BOOL darkensBackgroundForEnabledTabs;
@property (readwrite) BOOL drawSeparators;
@property (nonatomic, strong) UIColor *enabledTabBackgrondColor;
@property (nonatomic, strong) UIFont *titlesFont;
@property (nonatomic, strong) UIColor *titlesFontColor;
@property (nonatomic, strong) UIColor *titlesEnableFontColor;
@property (nonatomic, strong) NSArray *tabItems;
@property (nonatomic, readwrite) HorizontalEdgeInsets horizontalInsets;

- (id)initWithFrame:(CGRect)frame andTabItems:(NSArray *)tabItems;
- (void)swtichTab:(RKTabItem *)tabItem;
- (void)updateTabItem:(RKTabItem *)tabItem;

@end
