//
//  SCRScrollMenu.h
//  SCRScrollMenuController
//
//  Created by Joe Shang on 8/20/14.
//  Copyright (c) 2014 Shang Chuanren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRScrollMenuItem.h"

@class SCRScrollMenu;
@protocol SCRScrollMenuDelegate <NSObject>

- (void)scrollMenu:(SCRScrollMenu *)scrollMenu didSelectedAtIndex:(NSUInteger)index;

@end

@interface SCRScrollMenu : UIView

@property (nonatomic, strong) UIImage      *backgroundImage;

@property (nonatomic, assign) NSUInteger    indicatorHeight;
@property (nonatomic, strong) UIColor      *indicatorColor;

@property (nonatomic, assign) NSUInteger    buttonPadding;
@property (nonatomic, assign) NSUInteger    buttonTitleSpacing;
@property (nonatomic, strong) NSDictionary *normalTitleAttributes;
@property (nonatomic, strong) NSDictionary *selectedTitleAttributes;
@property (nonatomic, strong) NSDictionary *normalSubtitleAttributes;
@property (nonatomic, strong) NSDictionary *selectedSubtitleAttributes;

@property (nonatomic, weak)   id<SCRScrollMenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)setButtonsByItems:(NSArray *)items;
- (void)insertButtonByItem:(SCRScrollMenuItem *)item atIndex:(NSUInteger)index;
- (void)removeButtonAtIndex:(NSUInteger)index;

- (void)scrollToIndex:(NSUInteger)index;
- (void)moveToIndex:(NSUInteger)index progress:(CGFloat)progress;

- (NSUInteger)currentIndex;

@end
