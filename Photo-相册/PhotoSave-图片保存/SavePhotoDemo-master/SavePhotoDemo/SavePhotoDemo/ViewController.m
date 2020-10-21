//
//  ViewController.m
//  SavePhotoDemo
//
//  Created by allison on 2018/8/11.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "BDFCustomPhotoAlbum.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic) UIImage *image;

/// 当前App对应的自定义相册
- (PHAssetCollection*)createCollection;
/// 返回刚才保存到【相机胶卷】的图片
- (PHFetchResult<PHAsset *> *)createdAssets;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.image = [UIImage imageNamed:@"image2"];
    self.imageView.image = self.image;
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
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
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
- (PHFetchResult<PHAsset *> *)createdAssets {
    // 同步执行修改操作
    NSError *error = nil;
    __block NSString *assertId = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        assertId =  [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
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
- (void)saveimageIntoAlbum {
    // 1.先保存图片到【相机胶卷】
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    if (createdAssets == nil) {
        NSLog(@"保存图片失败");
    }
    // 2.拥有一个【自定义相册】
    PHAssetCollection * assetCollection = self.createCollection;
    if (assetCollection == nil) {
        NSLog(@"创建相册失败");
    }
    // 3.将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        // [requtes addAssets:@[placeholder]];
        [requtes insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if (error) {
        NSLog(@"保存图片失败");
    } else {
        NSLog(@"保存图片成功");
    }
}
- (IBAction)saveToNewThumb:(UIButton *)sender {
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
                [self saveimageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                NSLog(@"因系统原因，无法访问相册");
            }
        });
    }];

}

- (IBAction)saveClick:(UIButton *)sender {
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数) 一般写nil
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    /* 1.先保存图片到【相机胶卷】(不能直接保存到自定义相册中)
        1> C语言函数
        2> AssetsLibrary框架  (iOS4支持，iOS9.0被废弃)
        3> Photos框架 (iOS 8.0支持 推荐使用)
       2.拥有一个【自定义相册】
        1> AssetsLibrary框架
        2> Photos框架
       3.将刚才保存到【相机胶卷】里面的图片引用到【自定义相册】
        1> AssetsLibrary框架
        2> Photos框架
     */
    
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

#pragma mark -- <直接调用封装的工具类保存图片到相册>
- (IBAction)shareInstanceSaveToNewThumb:(UIButton *)sender {
    [[BDFCustomPhotoAlbum shareInstance]saveToNewThumb:self.imageView.image];
}


@end
