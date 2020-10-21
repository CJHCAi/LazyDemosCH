//
//  UIViewController+Theme.h
//  GifMaker_ObjC
//
//  Created by Ayush Saraswat on 4/26/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Theme)

typedef enum {
    Light,
    Dark,
    DarkTranslucent
} Theme;

- (void)applyTheme:(Theme)theme;

@end
