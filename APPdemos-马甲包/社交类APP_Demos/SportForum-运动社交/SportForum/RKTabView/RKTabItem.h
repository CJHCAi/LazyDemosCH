//  Created by Rafael Kayumov (RealPoc).
//  Copyright (c) 2013 Rafael Kayumov. License: MIT.

#import <Foundation/Foundation.h>

typedef enum {
    TabStateEnabled,
    TabStateDisabled
} TabState;

typedef enum {
    TabTypeUsual,
    TabTypeButton,
    TabTypeUnexcludable
} TabType;

@interface RKTabItem : NSObject

@property (readwrite) TabState tabState;
@property (readonly) TabType tabType;
@property (nonatomic, assign, readonly) id target;
@property (readonly) SEL selector;
@property (nonatomic, strong) UIColor *enabledBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleFontColor;
@property (nonatomic, strong) UIColor *titleEnableFontColor;
@property (nonatomic, strong) UIImage *imageEnabled;
@property (nonatomic, strong) UIImage *imageDisabled;
@property (nonatomic, strong, readonly) UIImage *imageForCurrentState;
@property(nonatomic, strong) void(^action)();

+ (RKTabItem *)createUsualItemWithImageEnabled:(UIImage *)imageEnabled
                               imageDisabled:(UIImage *)imageDisabled Action:(void(^)())action;

+ (RKTabItem *)createUnexcludableItemWithImageEnabled:(UIImage *)imageEnabled
                               imageDisabled:(UIImage *)imageDisabled;

+ (RKTabItem *)createButtonItemWithImage:(UIImage *)image
                         target:(id)target
                       selector:(SEL)selector;

- (void)switchState;

@end
