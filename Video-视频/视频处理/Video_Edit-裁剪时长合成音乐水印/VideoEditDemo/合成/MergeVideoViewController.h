//
//  MergeVideoViewController.h
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/8.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MergeVideoViewController : UIViewController
- (IBAction)selectFirstVideoAction:(UIButton *)sender;
- (IBAction)selectSecondVideoAction:(UIButton *)sender;
- (IBAction)mergeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end
