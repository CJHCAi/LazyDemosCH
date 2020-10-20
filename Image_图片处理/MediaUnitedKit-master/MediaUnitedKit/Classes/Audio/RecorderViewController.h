//
//  RecorderViewController.h
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/22.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  音频录制
//

#import <UIKit/UIKit.h>

@interface RecorderViewController : UIViewController

@property(nonatomic, copy) void (^mp3FileNameBlock)(NSString *mp3FileName);

@end
