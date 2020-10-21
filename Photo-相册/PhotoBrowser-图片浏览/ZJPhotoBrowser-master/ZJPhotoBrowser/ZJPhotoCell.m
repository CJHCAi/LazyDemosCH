//
//  ZJPhotoCell.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJPhotoCell.h"
@implementation ZJPhotoCell


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        _zjPhotoView = [[ZJPhotoView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame)- kPhotoImageEdgeWidth, CGRectGetHeight(frame))];
        [self.contentView addSubview:_zjPhotoView];
    }
    return self;
}


-(void)setZjPhoto:(ZJPhoto *)zjPhoto {

    _zjPhoto = zjPhoto;
    _zjPhotoView.zjPhoto = _zjPhoto;
}


@end
