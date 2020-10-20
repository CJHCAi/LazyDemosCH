//
//  CameraViewController.h
//  集成GPUImage2
//
//  Created by 七啸网络 on 2017/8/23.
//  Copyright © 2017年 youbei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewModel.h"
#import "CamerasManager.h"
@interface CameraViewController : UIViewController
@property(nonatomic,strong)CamerasManager * manager;
@property(nonatomic,strong)CameraViewModel * cameraViewModel;

@end
