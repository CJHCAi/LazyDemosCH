//
//  ZJPhotoCell.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhoto.h"
#import "ZJPhotoView.h"
#define kPhotoImageEdgeWidth  20

@interface ZJPhotoCell : UICollectionViewCell

@property(nonatomic, strong)ZJPhotoView *zjPhotoView;
@property(nonatomic, strong)ZJPhoto *zjPhoto;
@property(nonatomic, strong)UIImageView *imageView;


@end
