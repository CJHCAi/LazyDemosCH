//
//  CTPhotoModel.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQPhotoModel.h"

@implementation ZQPhotoModel

- (instancetype)initWithPHAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
        _bSelected = NO;
        _duration = asset.duration;
    }
    return self;
}
@end
