//
//  LCTabBarItem.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015 Leo <leodaxia@gmail.com>
//
//  Copyright (c) 2015-2017 Leo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LCTabBarItem.h"
#import "LCTabBarBadge.h"
#import "LCTabBarCONST.h"

@interface LCTabBarItem ()

@property (nonatomic, strong) LCTabBarBadge *tabBarBadge;

@end

@implementation LCTabBarItem

- (void)dealloc {
    
    [self.tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
    [self.tabBarItem removeObserver:self forKeyPath:@"title"];
    [self.tabBarItem removeObserver:self forKeyPath:@"image"];
    [self.tabBarItem removeObserver:self forKeyPath:@"selectedImage"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.tabBarBadge = [[LCTabBarBadge alloc] init];
        [self addSubview:self.tabBarBadge];
    }
    return self;
}

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio {
    
    if (self = [super init]) {
        
        self.itemImageRatio = itemImageRatio;
    }
    return self;
}

#pragma mark -

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    
    _itemTitleFont = itemTitleFont;
    
    self.titleLabel.font = itemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    
    _itemTitleColor = itemTitleColor;
    
    [self setTitleColor:itemTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    
    _selectedItemTitleColor = selectedItemTitleColor;
    
    [self setTitleColor:selectedItemTitleColor forState:UIControlStateSelected];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
    self.tabBarBadge.badgeTitleFont = badgeTitleFont;
}

#pragma mark -

- (void)setTabBarItemCount:(NSInteger)tabBarItemCount {
    
    _tabBarItemCount = tabBarItemCount;
    
    self.tabBarBadge.tabBarItemCount = self.tabBarItemCount;
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    
    _tabBarItem = tabBarItem;
    
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationTabBarItemChanged object:nil];
    
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    
    self.tabBarBadge.badgeValue = self.tabBarItem.badgeValue;
}

#pragma mark - Reset TabBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * self.itemImageRatio;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0.f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = contentRect.size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
