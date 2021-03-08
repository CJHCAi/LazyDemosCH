//
//  CTAlbumModel.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZQAlbumModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) id fetchResult;//PHFetchResult<PHAsset *> *

- (instancetype)initWithPHAssetCollection:(PHAssetCollection *)collection
                                  options:(PHFetchOptions *)options;


@end
