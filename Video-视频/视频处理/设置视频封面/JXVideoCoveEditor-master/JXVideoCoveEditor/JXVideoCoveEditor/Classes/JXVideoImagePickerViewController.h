//
//  JXVideoImagePickerViewController.h
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JXVideoImageGenerator.h"


@interface JXVideoImagePickerViewController : UIViewController


/** asset*/
@property (nonatomic, strong) AVAsset *asset;

/** videoPath*/
@property (nonatomic, strong)NSString *videoPath;

@property (nonatomic, copy) SingleImageClosure generatedKeyframeImageHandler;

/** imageGenerator*/
@property (nonatomic, strong)JXVideoImageGenerator *imageGenerator;

@end
