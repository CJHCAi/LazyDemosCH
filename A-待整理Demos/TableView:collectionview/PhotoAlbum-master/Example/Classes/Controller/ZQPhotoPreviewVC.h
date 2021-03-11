//
//  ZQPhotoPreviewVC.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@class ZQPhotoModel;
@class ZQPhotoPreviewVC;

@protocol ZQPhotoPreviewVCDelegate <NSObject>

- (void)ZQPhotoPreviewVC:(ZQPhotoPreviewVC*)vc changeSelection:(NSArray<ZQPhotoModel*>*)selection;

@end



@interface ZQPhotoPreviewVC : UIViewController

@property (nonatomic, strong) NSArray<ZQPhotoModel *> *models;
@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, strong) NSMutableArray<ZQPhotoModel *> *selected;


@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, assign) BOOL bSingleSelect;

@property (nonatomic, weak) id<ZQPhotoPreviewVCDelegate> delegate;

- (void)getCurrentCrop:(CGRect)rect;
@end
