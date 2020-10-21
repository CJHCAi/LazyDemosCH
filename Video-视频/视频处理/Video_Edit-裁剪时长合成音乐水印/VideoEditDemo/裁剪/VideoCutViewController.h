//
//  VideoCutViewController.h
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/6.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGVideoTrimmer.h"

@interface VideoCutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIView *videoLayer;

@property (weak, nonatomic) IBOutlet ICGVideoTrimmerView *trimmerView;
- (IBAction)importAction:(UIButton *)sender;
- (IBAction)saveAction:(UIButton *)sender;

@end
