//
//  PopUpViewController.h
//  NMPopUpView
//
//  Created by Nikos Maounis on 9/12/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface PopUpViewController : UIViewController

@property (weak, nonatomic) UIView *popUpView;
@property (weak, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *messageLabel;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
