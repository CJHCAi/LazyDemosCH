//
//  BDFCustomPhotoAlbum.m
//  SavePhotoDemo
//
//  Created by allison on 2018/8/13.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "BDFCustomPhotoAlbum.h"
#import <Photos/Photos.h>

@interface BDFCustomPhotoAlbum() <NSCopying, NSMutableCopying>
@end

@implementation BDFCustomPhotoAlbum

static BDFCustomPhotoAlbum *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}

#pragma mark -- <获取当前App对应的自定义相册>
- (PHAssetCollection*)createCollection {
    //获取App名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
    //抓取所有【自定义相册】
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 查询当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    //当前对应的app相册没有被创建
    NSError *error = nil;
    __block NSString *createCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        //创建一个【自定义相册】(需要这个block执行完，相册才创建成功)
        createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        NSLog(@"创建相册失败");
        return nil;
    }
    // 根据唯一标识，获得刚才创建的相册
    PHAssetCollection *createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    return createCollection;
}

#pragma mark -- <获取相片>
- (PHFetchResult<PHAsset *> *)createdAssets:(nonnull UIImage *)image {
    // 同步执行修改操作
    NSError *error = nil;
    __block NSString *assertId = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        assertId =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) {
        NSLog(@"保存失败");
        return nil;
    }
    // 获取相片
    PHFetchResult<PHAsset *> *createdAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[assertId] options:nil];
    return createdAssets;
}

#pragma mark --  <保存图片到相册>
- (void)saveimageIntoAlbum:(nonnull UIImage *)image  {
    // 1.先保存图片到【相机胶卷】
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssets:image];
    if (createdAssets == nil) {
        // NSLog(@"保存图片失败");
        [self showAlertMessage:@"保存图片失败"];
    }
    // 2.拥有一个【自定义相册】
    PHAssetCollection * assetCollection = self.createCollection;
    if (assetCollection == nil) {
        // NSLog(@"创建相册失败");
        [self showAlertMessage:@"创建相册失败"];
    }
    // 3.将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        // [requtes addAssets:@[placeholder]];
        [requtes insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if (error) {
        // NSLog(@"保存图片失败");
        [self showAlertMessage:@"保存图片失败"];
    } else {
        // NSLog(@"保存图片成功");
        [self showAlertMessage:@"创建相册失败"];
    }
}

- (void)saveToNewThumb:(nonnull UIImage *)image {
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 检查用户访问权限
    // 如果用户还没有做出选择，会自动弹框
    // 如果之前已经做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied ) { // 用户拒绝当前App访问权限
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    NSLog(@"提醒用户打开开关");
                }
            } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问
                [self saveimageIntoAlbum:image];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                NSLog(@"因系统原因，无法访问相册");
            }
        });
    }];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)showAlertMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"确定", nil];
    
    [alert show];
}



@end
