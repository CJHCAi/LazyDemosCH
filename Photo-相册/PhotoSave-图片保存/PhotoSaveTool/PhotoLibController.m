//
//  PhotoLibController.m
//  GetAddressBookInfo
//
//  Created by Ed on 2016/3/2.
//  Copyright © 2016年 Ed. All rights reserved.
//

#import "PhotoLibController.h"

@implementation PhotoLibController
/* 用名称取得自定义相簿 */
+ (PHAssetCollection*)getAssetCollectionWithName:(NSString*)name
{
    __block PHAssetCollection* assetCollection;
    PHFetchResult* assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                               subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                               options:nil];
    [assetCollections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        if ([collection.localizedTitle isEqualToString:name]) {
            assetCollection = collection;
            *stop = YES;
        }
    }];
    
    if (assetCollection) {
        return assetCollection;
    } else {
        return nil;
    }
}
/**创建自定义相簿*/
+ (void)createAssetCollectionWithName:(NSString*)name completion:(void(^)(NSString* errorMsg))completion
{
    if ([name length] != 0) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                completion(nil);
            } else {
                completion(error.localizedDescription);
            }
        }];
    } else {
        completion(@"Error: create asset collection with empty name.");
    }
}
/*创建自定义相簿，并返回相簿*/
+ (void)setAssetCollectionWithName:(NSString*)name completion:(void(^)(NSString* errorMsg, PHAssetCollection* assetCollection))completion
{
    [self requestPhotoAlbumPermissions:^(BOOL permission) {
        
        if (permission) {
            PHAssetCollection* assetCollection = [self getAssetCollectionWithName:name];
            if (assetCollection) {
                completion(nil,assetCollection);
            } else {
                [self createAssetCollectionWithName:name completion:^(NSString *errorMsg) {
                    if (errorMsg) {
                        completion(errorMsg, nil);
                    } else {
                        completion(nil, [self getAssetCollectionWithName:name]);
                    }
                }];
            }
        } else {
            completion(@"Error: PHAuthorizationStatusDenied",nil);
        }
    }];
}


/*将图片存到自定义相簿中 */
+ (void)addAssetsToAlbumWithImageArray:(NSMutableArray*)imageArray toAssetCollection:(PHAssetCollection*)assetCollection completion:(void(^)(NSString* errorMsg))completion
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        NSMutableArray* assetsArray = [[NSMutableArray alloc] init];
        for (UIImage* image in imageArray) {
            
            PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            PHObjectPlaceholder* assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
            
            [assetsArray addObject:assetPlaceholder];
        }
        
        PHAssetCollectionChangeRequest* collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        
        [collectionChangeRequest addAssets:assetsArray];
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        if (success) {
            completion(nil);
        } else {
            completion(error.localizedDescription);
        }
    }];
}

/** 请求相簿授权*/
+ (void)requestPhotoAlbumPermissions:(void(^)(BOOL permission))block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status)
    {
        case PHAuthorizationStatusAuthorized:
            block(YES);
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
             {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized) {
                     block(YES);
                 } else {
                     block(NO);
                 }
             }];
            break;
        }
        default:
            block(NO);
            break;
    }
}

@end
