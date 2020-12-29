//
//  UIWebView+GUIFixes.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (GUIFixes)

/**
 *  @brief      The custom input accessory view.
 */
@property (nonatomic, strong, readwrite) UIView* customInputAccessoryView;

/**
 *  @brief      Wether the UIWebView will use the fixes provided by this category or not.
 */
@property (nonatomic, assign, readwrite) BOOL usesGUIFixes;

@end
