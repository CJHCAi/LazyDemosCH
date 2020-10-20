//
//  SABTools.m
//  音频转视频
//
//  Created by dszhangyu on 2018/8/15.
//  Copyright © 2018年 dszhangyu. All rights reserved.
//

#import "SABTools.h"
#import <Photos/Photos.h>

#define CeshiPhoto @"Ceshi"//相册文件夹名称
@implementation SABTools
//  TODO: 保存视频到相册中
+(void)saveVideoForPhoto:(NSString *)videoPath complet:(void (^)(NSString *descirp))complete{
    if (!videoPath) {
        if (complete) {
            complete(@"文件已损坏");
        }
        return;
    }
    [SABTools photoAuthorization:^(bool authori) {
        if (authori) {
            __block NSString *localIdentifier;
            [SABTools createFolderForPhotoComplete:^(BOOL success) {
                if (success) {
                    NSURL *url = [NSURL fileURLWithPath:videoPath];
                    //标识保存到系统相册中的标识
                    //首先获取相册的集合
                    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
                    //对获取到集合进行遍历
                    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        PHAssetCollection *assetCollection = obj;
                        //folderName是我们写入照片的相册
                        if ([assetCollection.localizedTitle isEqualToString:CeshiPhoto])  {
                            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                //请求创建一个Asset
                                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                                //请求编辑相册
                                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                                //为Asset创建一个占位符，放到相册编辑请求中
                                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                                //相册中添加视频
                                [collectonRequest addAssets:@[placeHolder]];
                                
                                localIdentifier = placeHolder.localIdentifier;
                            } completionHandler:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"保存视频成功!");
                                    if (complete) {
                                        complete(@"已成功保存到相册");
                                    }
                                } else {
                                    if (complete) {
                                        complete(@"保存失败，请稍后尝试");
                                    }
                                    NSLog(@"保存视频失败:%@", error);
                                }
                            }];
                        }
                    }];
                }else{
                    if (complete) {
                        complete(@"保存失败，请稍后尝试");
                    }
                    NSLog(@"文件夹不存在");
                }
            }];
        }else{
            if (complete) {
                complete(@"请在设置中打开相册权限");
            }
            NSLog(@"用户没有授权");
        }
    }];
}

+(void)photoAuthorization:(void(^)(bool authori))authori{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            if (authori) {
                authori(NO);
            }
        }
        else if (status == PHAuthorizationStatusAuthorized)
        {
            if (authori) {
                authori(YES);
            }
        }
    }];
}

//  TODO: 相册内部文件夹
+(void)createFolderForPhotoComplete:(void(^)(BOOL success))complete{
    __block BOOL createSuccess = YES;
    if (![SABTools isExitPhotoFilePath:CeshiPhoto]) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //添加HUD文件夹
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:CeshiPhoto];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"创建相册文件夹成功!");
                createSuccess = YES;
            } else {
                NSLog(@"创建相册文件夹失败:%@", error);
                createSuccess = NO;
            }
            if (complete) {
                complete(success);
            }
        }];
    }else{
        NSLog(@"相册文件路径已存在");
        if (complete) {
            complete(YES);
        }
    }
}

//  TODO:  判断相册中是否存在folderName文件夹
+(BOOL)isExitPhotoFilePath:(NSString * )folderName{
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:folderName])  {
            isExisted = YES;
        }
    }];
    return isExisted;
}

@end
