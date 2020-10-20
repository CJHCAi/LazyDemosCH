//
//  MMPhotoPreviewController.h
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  图片预览

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MMPhotoPreviewController : UIViewController

@property (nonatomic,strong) NSMutableArray<PHAsset *> *assetArray;
@property (nonatomic,copy) void(^photoDeleteBlock)(PHAsset *asset);

@end
