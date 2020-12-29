//
//  WallpaperCell.h
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//  collectionCell

#import <UIKit/UIKit.h>

@class WallPaper;

@class PixabayModel;

@interface WallpaperCell : UICollectionViewCell

- (void)setPixabayModel:(PixabayModel *)model;

//-(void)setWallpaper:(WallPaper *)wallpaper;

@end
