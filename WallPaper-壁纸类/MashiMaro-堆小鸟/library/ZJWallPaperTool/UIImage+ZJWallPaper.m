//
//  UIImage+ZJWallPaper.m
//  ZJWallPaperDemo
//
//  Created by onebyte on 15/7/17.
//  Copyright (c) 2015年 onebyte. All rights reserved.
//

#import "UIImage+ZJWallPaper.h"
//#import "PLStaticWallpaperImageViewController.h"
#import "ZJWallPaperVC.h"
#import <objc/runtime.h>

@interface UIImage ()

@end

@implementation UIImage (ZJWallPaper)

/*!
 *  保存为桌面壁纸和锁屏壁纸
 */
- (void)zj_saveAsHomeScreenAndLockScreen
{
    [self.zj_wallPaperVC setImageAsHomeScreenAndLockScreenClicked:nil];
}

/*!
 *  保存为桌面壁纸
 */
- (void)zj_saveAsHomeScreen
{
    [self.zj_wallPaperVC setImageAsHomeScreenClicked:nil];

}

/*!
 *  保存为锁屏壁纸
 */
- (void)zj_saveAsLockScreen
{
    [self.zj_wallPaperVC setImageAsLockScreenClicked:nil];
}

/*!
 *  保存到照片库
 */
- (void)zj_saveToPhotos
{
    UIImageWriteToSavedPhotosAlbum(self, nil,nil, NULL);
}


-(ZJWallPaperVC *)zj_wallPaperVC
{
    ZJWallPaperVC * wallPaperVC = [[ZJWallPaperVC alloc] initWithUIImage:self];
    wallPaperVC.allowsEditing = YES;
    wallPaperVC.saveWallpaperData = YES;
    
    return wallPaperVC;
}

@end
