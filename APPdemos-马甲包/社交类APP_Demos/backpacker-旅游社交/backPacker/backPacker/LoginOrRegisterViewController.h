//
//  LoginOrRegisterViewController.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-5-23.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOrRegisterViewController : UIViewController
//标志目前是登陆还是register状态，login为1，register为0；
@property (strong, nonatomic) IBOutlet UIView *childView;
@property (strong,nonatomic)IBOutlet NSString *loginOrRegister;
@property (strong, nonatomic) IBOutlet UISegmentedControl *loginOrRegisterSegment;
- (IBAction)lrSegmentPressed:(id)sender;

@end
