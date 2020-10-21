//
//  AddBackgroundMusicViewController.h
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/7.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBackgroundMusicViewController : UIViewController
- (IBAction)importVideoAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *importVideoButton;
@property (weak, nonatomic) IBOutlet UIView *videoView;
- (IBAction)addBackgroundMusicAction:(UIButton *)sender;

@end
