//
//  UIViewController+Theme.m
//  GifMaker_ObjC
//
//  Created by Ayush Saraswat on 4/26/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "UIViewController+Theme.h"

@implementation UIViewController (Theme)

- (void)applyTheme:(Theme)theme {
    switch (theme) {
        case Light:
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:102.0/255.0 alpha:1.0]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0]}];

            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            break;
            
        case Dark:
            [self.view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0]];

            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setTranslucent:YES];
            [self.navigationController.view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0]];
            [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:1.0]];
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
            
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

            break;
            
        case DarkTranslucent:
            [self.view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:61.0/255.0 blue:73.0/255.0 alpha:0.9]];
            
            break;
        
        default:
            break;
    }
}

@end
