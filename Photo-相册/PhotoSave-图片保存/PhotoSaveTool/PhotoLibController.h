//
//  PhotoLibController.h
//  GetAddressBookInfo
//
//  Created by Ed on 2016/3/2.
//  Copyright © 2016年 Ed. All rights reserved.
//

/*-------------------

 將圖片存入手機相簿，並建立自訂相簿的使用範例：
 [PhotoLibController setAssetCollectionWithName:PHOTO_ALBUM_NAME completion:^(NSString *errorMsg, PHAssetCollection *assetCollection) {
 
     [PhotoLibController addAssetsToAlbumWithImageArray:imageArray toAlbum:assetCollection completion:^(NSString *errorMsg) {
 
     }];
 }];
 
-------------------*/

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoLibController : NSObject

/*创建自定义相簿，并返回相簿*/
+ (void)setAssetCollectionWithName:(NSString*)name completion:(void(^)(NSString* errorMsg, PHAssetCollection* assetCollection))completion;

/*将图片存到自定义相簿中 */
+ (void)addAssetsToAlbumWithImageArray:(NSMutableArray*)imageArray toAssetCollection:(PHAssetCollection*)assetCollection completion:(void(^)(NSString* errorMsg))completion;

/* 用名称取得自定义相簿 */
+ (PHAssetCollection*)getAssetCollectionWithName:(NSString*)name;

/* 创建一个自定义相簿*/
+ (void)createAssetCollectionWithName:(NSString*)name completion:(void(^)(NSString* errorMsg))completion;

@end
