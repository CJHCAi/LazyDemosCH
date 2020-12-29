//
//  PLWallpaperImageViewController.h
//  ZJWallPaperDemo
//
//  Created by onebyte on 15/7/17.
//  Copyright (c) 2015年 onebyte. All rights reserved.
//

@interface PLWallpaperImageViewController : UIViewController

- (instancetype)initWithUIImage:(UIImage *)image;

- (void)_savePhoto;

- (void)setImageAsHomeScreenAndLockScreenClicked:(id)arg1;
- (void)setImageAsHomeScreenClicked:(id)arg1;
- (void)setImageAsLockScreenClicked:(id)arg1;

@property BOOL saveWallpaperData;
@end
