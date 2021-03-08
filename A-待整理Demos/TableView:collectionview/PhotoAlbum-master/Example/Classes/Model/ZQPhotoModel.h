//
//  CTPhotoModel.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface ZQPhotoModel : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, assign) int32_t requestID;
//@property (nonatomic, strong) UIImage *videoCoverImage;

- (instancetype)initWithPHAsset:(PHAsset *)asset;

@end
