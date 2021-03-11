//
//  CTAlbumModel.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQAlbumModel.h"


@interface ZQAlbumModel()
@property (nonatomic, strong) PHAssetCollection *collection;
@end

@implementation ZQAlbumModel

- (instancetype)initWithPHAssetCollection:(PHAssetCollection *)collection
                                  options:(PHFetchOptions *)options
{
    self = [super init];
    if (self) {
        _collection = collection;
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        _count = assets.count;
        _name = collection.localizedTitle;
        _identifier = collection.localIdentifier;
        _fetchResult = assets;
    }
    return self;
}
@end
