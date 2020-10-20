//
//  SHJBaseViewController.h
//  TestASDK
//
//  Created by shj on 2018/2/14.
//  Copyright © 2018年 shj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBaseViewController : UIViewController

- (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target selector:(SEL)selector;
- (void)alert:(NSString *)content;

@end
