//
//  SDEditRichImageViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/11.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDEditRichImageViewController : UIViewController

@property (nonatomic, strong) UIImage * originImage;

/**
 进入 滤镜的功能界面
 */
- (void)pushFilterViewController;

/**
 进入剪切的功能界面
 */
- (void)pushCutViewController;

/**
 进入贴纸的功能界 main
 */
- (void)pushDecorateViewController;


/**
 进入画笔的功能界面
 */
- (void)pushGraffitiViewController;

@end
