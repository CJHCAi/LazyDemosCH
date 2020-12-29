//
//  MenuViewController.h
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

// 菜单控制器

#import <UIKit/UIKit.h>
//库的引用
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "REFrostedViewController.h"

@interface MenuViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIImagePickerControllerQualityType                  _qualityType;//视频质量
    NSURL*                                              _videoURL;//视频地址
    NSString*                                           _mp4Path;
    UIAlertView*                                        _alert;
    NSDate*                                             _startDate;
    NSString*                                           _mp4Quality;
    UIImagePickerController*                            pickerView;//视频录制view
}


@end
