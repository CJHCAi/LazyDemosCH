//
//  ZJPhotoView.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhoto.h"
#define kZJPhotoScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kZJPhotoScreenHeight [UIScreen mainScreen].bounds.size.height
typedef NS_ENUM(NSInteger, ZJPhotoTapTypeName) {
    
    //单击
    ZJPhotoTapTypeOne = 0,
    
    //长按
    ZJPhotoTapTypeLong = 1 ,
    
};

@class ZJPhotoView;
@protocol ZJPhotoViewDelegate <NSObject>

- (void)zjPhotoView:(ZJPhotoView *)photoView  receiveTapWithZJPhotoTapType:(ZJPhotoTapTypeName)tapTypeName;


@end


@interface ZJPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong)ZJPhoto *zjPhoto;

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, weak)id<ZJPhotoViewDelegate>photoDelegate;

@property (nonatomic, assign) BOOL bigImageHasLoad;//是否成功加载大图


@end
