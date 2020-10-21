//
//  WaterViewController.h
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/6.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterViewController : UIViewController
- (IBAction)ImportVideoAction:(UIButton *)sender;
- (IBAction)addWaterAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end
