//
//  BaseViewController.h
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLLabel.h"
#import "MLLinkLabel.h"

#import "NSString+MLExpression.h"
#import "NSAttributedString+MLExpression.h"


#import "UIView+CateGory.h"


#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

@interface BaseViewController : UIViewController

@property ( nonatomic,strong ) MLLabel *label;

@property ( nonatomic,strong ) UIButton *button;

- (Class)lableClass;

- (NSInteger)resultCount;

- (void)changeToresult:(int)result;

@end
