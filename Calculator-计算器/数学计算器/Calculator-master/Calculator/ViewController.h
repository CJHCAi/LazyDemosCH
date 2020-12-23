//
//  ViewController.h
//  Calculator
//
//  Created by liaosipei on 15/8/20.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *portraitDisplay;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (strong, nonatomic) IBOutlet UIView *additionalOptions;

@end

