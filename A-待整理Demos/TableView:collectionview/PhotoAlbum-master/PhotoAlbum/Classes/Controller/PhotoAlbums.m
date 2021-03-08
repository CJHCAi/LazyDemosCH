//
//  PhotoAlbums.m
//  Tripinsiders
//
//  Created by ZhouQian on 16/7/28.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import "PhotoAlbums.h"
#import "ZQAlbumNavVC.h"
#import <Photos/Photos.h>
#import "ZQPhotoFetcher.h"
#import "ZQTools.h"

@implementation PhotoAlbums

//video
+ (void)photoVideoWithMaxDurtion:(NSTimeInterval)duration
                        Delegate:(id)delegate
      updateUIFinishPickingBlock:(void (^)(UIImage *cover))uiUpdateBlock
     didFinishPickingVideoHandle:(void (^ )(NSURL *url, UIImage *cover, id avAsset))didFinishPickingVideoHandle {
    void (^block)(void) = ^{
        ZQAlbumNavVC *navVc = [[ZQAlbumNavVC alloc] initWithMaxImagesCount:1 type:ZQAlbumTypeVideo bSingleSelect:YES];
        navVc.albumDelegate = delegate;
        navVc.maxVideoDurationInSeconds = duration;
        navVc.updateUIFinishVideoPicking = uiUpdateBlock;
        navVc.didFinishPickingVideoHandle = didFinishPickingVideoHandle;
        [[ZQTools rootViewController] presentViewController:navVc animated:YES completion:nil];
    };
    
    [PhotoAlbums photoWithBlock:block];
}


//multi-select
+ (void)photoMultiSelectWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock {
    [PhotoAlbums photoWithMaxImagesCount:maxImagesCount type:ZQAlbumTypePhoto bSingleSelect:NO crop:NO delegate:delegate didFinishPhotoBlock:[finishBlock copy]];
}

//single select
+ (void)photoSingleSelectWithCrop:(BOOL)crop delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock {
    [PhotoAlbums photoWithMaxImagesCount:1 type:ZQAlbumTypePhoto bSingleSelect:YES crop:crop delegate:delegate didFinishPhotoBlock:[finishBlock copy]];
}


+ (void)photoWithMaxImagesCount:(NSInteger)maxImagesCount type:(ZQAlbumType)type bSingleSelect:(BOOL)bSingleSelect crop:(BOOL)bEnableCrop delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock {
    
    void (^block)(void) = ^{
        ZQAlbumNavVC *navVc = [[ZQAlbumNavVC alloc] initWithMaxImagesCount:maxImagesCount type:type bSingleSelect:bSingleSelect];
        navVc.albumDelegate = delegate;
        navVc.bEnableCrop = bEnableCrop;
        navVc.didFinishPickingPhotosHandle = finishBlock;
        [[ZQTools rootViewController] presentViewController:navVc animated:YES completion:nil];
    };
    
    [PhotoAlbums photoWithBlock:block];
}


+ (void)photoWithBlock:(void(^)(void))block {
    if (![ZQPhotoFetcher authorizationStatusAuthorized]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status != PHAuthorizationStatusAuthorized) {
                    [PhotoAlbums alertAction];
                }
                else {
                    block();
                }
            });
        }];
    }
    else {
        block();
    }
}

+ (void)alertAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:_LocalizedString(@"OPERATE_PRIVACY") preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:_LocalizedString(@"OPERATION_CANCEL") style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *set = [UIAlertAction actionWithTitle:_LocalizedString(@"SETTING") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //go to setting page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert addAction:cancel];
    [alert addAction:set];
    [[ZQTools rootViewController] presentViewController:alert animated:YES completion:NULL];
}
@end
