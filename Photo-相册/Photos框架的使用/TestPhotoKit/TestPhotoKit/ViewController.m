//
//  ViewController.m
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//
#import <Photos/Photos.h>
#import "ViewController.h"
#import "AlbumController.h"


#import "WZPhotoCatalogueController.h"
#import "WZRemoteImageBrowseController.h"
#import "WZMediaFetcher.h"

@interface ViewController ()<WZProtocolMediaAsset>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //权限请求
    [NSObject requestPhotosLibraryAuthorization:nil];
    // 列出所有相册智能相册
//    WZMediaFetcher;
//    PHFetchOptions *fetchResoultOption = [[PHFetchOptions alloc] init];
//    fetchResoultOption.includeHiddenAssets = false;
//    fetchResoultOption.includeAllBurstAssets = false;
//    
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchResoultOption];
//     [PHCollection fetchTopLevelUserCollectionsWithOptions:fetchResoultOption];
//    
//    [smartAlbums enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[PHAssetCollection class]]) {
//            PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
//            NSLog(@"%@", assetCollection.localizedTitle);
//            if ([assetCollection canPerformEditOperation:PHCollectionEditOperationDeleteContent]) {
////             PHImageManager
//            }
//        }
//    }];
//    NSLog(@"smartAlbums.count：%ld", smartAlbums.count);
    
//    PHImageManager PHImageManager
    
    // 列出所有用户创建的相册
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:fetchResoultOption];
    
 
//  NSArray <WZMediaAssetCollection *>* array = [WZMediaFetcher customMediaAssetCollectionOnlyImageHybirdVideoAsset];
//    for (WZMediaAssetCollection *collection in array) {
//        NSLog(@"%@", collection);
////        collection.assetCollection
//        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection.assetCollection options:nil];
//        NSLog(@"%ld", result.count);
//        for (int i = 0; i < result.count; i++) {
//            
//        }
//    }
    
    [NSString stringWithFormat:@"%@", 0];
    int array[10];
    array[0] = 1;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (IBAction)allPhotos:(id)sender {
    AlbumController *ACVC = [[AlbumController alloc] init];
    [self.navigationController pushViewController:ACVC animated:YES];
}

- (IBAction)pictureSet:(id)sender {
    /*
     1、 首次加载APP时出现的问题：仅会获取相应的权限 而不会响应方法
     */
    //每次访问相册都会调用这个handler  检查改app的授权情况
    //PHPhotoLibrary
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //code
        }
    }];
    
    /*
     2、获取所有图片（注意不能在胶卷中获取图片，因为胶卷中的图片包含了video的显示图）
     */
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//这样获取
    
    /*
     3、使用PHImageManager请求时的回调同步or异步时、block回调次数的问题
     */
    
    /*
     4、回调得出的图片size的问题: 由3个参数决定
     */
    /*
     在ShowAlbumViewController 中观察
     
     在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
     当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
     时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
     
     而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
     */
    
    
    /*
     5、回调中info字典key消失的问题: 当最终获取到的图片的size的高／宽没有一个能达到原有的图片size的高／宽时 部分key 会消失
     */
    
    
    //    PHAsset 用户照片库中一个单独的资源，简单而言就是单张图片或者视音频的元数据吧
    
    //    PHAsset 组合而成 PHAssetCollection(PHCollection)   一个单独的资源集合(PHAssetCollection)可以是照片库中相簿中一个相册或者照片中一个时刻，或者是一个特殊的“智能相册”。这种智能相册包括所有的视频集合，最近添加的项目，用户收藏，所有连拍照片等
    
    //    PHCollectionList 则是包含PHAssetCollection的PHAssetCollection。因为它本身就是 PHCollection，所以集合列表可以包含其他集合列表，它们允许复杂的集合继承。例子：年度->精选->时刻
    
    //    PHFetchResult 某个系列（PHAssetCollection）或者是相册（PHAsset）的返回结果，一个集合类型，PHAsset 或者 PHAssetCollection 的类方法均可以获取到
    
    //    PHImageManager 处理图片加载，加载图片过程有缓存处理
    
    //    PHImageManager(PHImageManager的抽象) 处理图像的整个加载过程的缓存 要加载大量资源的缩略图时可以使用该类的startCachingImage... 预先将一些图像加载到内存中，达到预先缓冲的效果
    
    //    PHImageRequestOptions 设置加载图片方式的参数()
    
    //    PHFetchOptions 集合资源的配置方式（按一定的(时间)顺序对资源进行排列、隐藏/显示某一个部分的资源集合）
    
    
    
    
    /*
     PHAssetCollectionTypeMoment      Moment中
     PHAssetCollectionTypeAlbum       用户创建的相册
     PHAssetCollectionTypeSmartAlbum  系统相册中//系统本来就拥有的相册 如Favorites、Videos、Camera Roll等
     */
    /*
     // PHAssetCollectionTypeAlbum regular subtypes
     PHAssetCollectionSubtypeAlbumRegular         = 2,
     PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
     PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
     PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
     PHAssetCollectionSubtypeAlbumImported        = 6,
     
     // PHAssetCollectionTypeAlbum shared subtypes
     PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,//照片流
     PHAssetCollectionSubtypeAlbumCloudShared     = 101,//iCloud 分享
     
     // PHAssetCollectionTypeSmartAlbum subtypes
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,//一般
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,//全景
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202,//视频
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,//收藏
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,//定时拍摄
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,//
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,//最近添加
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207,//连拍
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,//慢动作视频
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,//用户相册
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,   //头像\肖像
     PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,     //截屏
     // Used for fetching, if you don't care about the exact subtype
     PHAssetCollectionSubtypeAny = NSIntegerMax
     */
    
    
    NSMutableArray *nameArr = [NSMutableArray array];//用于存储assets's名字
    NSMutableArray *assetArr = [NSMutableArray array];//用于存储assets's内容
    
    // 获取系统设置的相册信息(其实也不完全  譬如没有<照片流>等)
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //此处option是对获取得到对 Collection 的配置
    /*
     //         例如按资源的创建时间排序
     PHFetchOptions *options = [[PHFetchOptions alloc] init];
     //    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
     
     options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]]; //其中：key是PHAsset类的属性   这是一个kvc
     PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
     NSLog(@"获取所有资源(photo/video)image的集合并且按照时间创建时间排序 = %ld",assetsFetchResults.count);
     */
    
    NSLog(@"系统相册的数目 = %ld",smartAlbums.count);
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        
        [nameArr addObject:collection.localizedTitle];//存储assets's名字
        [assetArr addObject:results];//存储assets's内容
        
        //        for (PHAsset *asset in results) {
        //             PHImageRequestOptions *opts = [[PHImageRequestOptions alloc] init]; // assets的配置设置
        //             opts.synchronous = YES;//同步 or 异步
        //             opts.resizeMode = PHImageRequestOptionsResizeModeExact;//assets中图片获取的模式
        //             opts.deliveryMode  = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        //             [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //
        //             }];
        //        }
    }
    
    //  用户自定义的资源
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [nameArr addObject:collection.localizedTitle];
        [assetArr addObject:assets];
    }
    
    //如果要添加照片流 可以打开此下的注释
    //    PHFetchResult *stream = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    //    for (PHAssetCollection *collection in stream) {
    //        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    //        [nameArr addObject:collection.localizedTitle];
    //        [assetArr addObject:assets];
    //    }/
    
    ShowSmartAblumTableViewController *VC = [[ShowSmartAblumTableViewController alloc] init];
    VC.albumNameArr = [NSMutableArray arrayWithArray:nameArr];
    VC.albumAssetsArr = [NSMutableArray arrayWithArray:assetArr];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)localImagesShow:(id)sender {
    [WZPhotoCatalogueController showPickerWithPresentedController:self];
}



- (IBAction)networkImagesShow:(id)sender {
    NSArray <NSString *>*imageArray = @[
                                          @"http://www.5fen.com/uploads/allimg/131215/98-131215160J50-L.png",
                                          @"http://pic6.nipic.com/20100305/3648835_130246001000_2.jpg",
                                          @"http://www.meijialx.com/UserFiles/5(1463).jpg",
                                          @"http://pic13.nipic.com/20110308/5754245_080416078000_2.jpg",
                                          @"http://pic4.nipic.com/20091202/753913_193359691330_2.jpg",
                                          @"http://pic25.nipic.com/20121210/7447430_215257628000_2.jpg",
                                          @"http://fj2.eastday.com/hdqxb2013/20130823_7/node757990/images/02347082.jpg",
                                          @"http://www.ovoschooling.com/UploadFile/486072.jpg",
                                          @"http://tse3.mm.bing.net/th?id=OIP.OVq4ZcSfgO0FTwlX7_LmLAEsC7&pid=15.1",
                                          @"http://www.chinanews.com/tp/hd2011/2013/06-05/U508P4T426D210589F16470DT20130605152842.jpg",
                                          @"http://photo.workercn.cn/html/files/2014-05/09/20140509113225015592189.jpg",
                                          @"http://image.xinmin.cn/2013/07/30/20130730082617093478.jpg",
                                          @"http://www.chinanews.com/tp/hd2011/2013/08-28/U508P4T426D240266F16470DT20130828154442.jpg",
                                          @"http://www.yeeed.com/wp-content/uploads/2014/03/ZhongGuo-14.jpg",
                                          @"http://finance.chinanews.com/life/hd/2013/07-01/U287P51T16D13832F435DT20130701161234.jpg",
                                          @"http://finance.chinanews.com/life/hd/2013/10-10/U217P51T16D14283F435DT20131010144853.jpg",
                                          @"http://finance.chinanews.com/life/hd/2013/10-10/U217P51T16D14270F435DT20131010134051.jpg",
                                          @"http://www.chinanews.com/tp/hd2011/2013/09-26/U508P4T426D249631F16470DT20130926153638.jpg",
                                          @"http://i2.chinanews.com/simg/hd/2014/05/09/5c8f0ca41814401db1b5f31309c9b086.jpg",
                                          @"http://imgbdb2.bendibao.com/guangzhou/20136/28/2013628155018139.jpg",
                                          @"http://i2.chinanews.com/simg/hd/2014/05/09/d773e709dc684ea5913fdd2427cab648.jpg",
                                          @"http://imgbdb2.bendibao.com/guangzhou/20136/28/2013628155016436.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955389&di=29e728418b6ebad1afadc96900bec3e7&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1308%2F17%2Fc6%2F24564406_1376704633091.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955389&di=c9d053bd2909a45c7441b9924fff6fdf&imgtype=0&src=http%3A%2F%2Ffe.topit.me%2Fe%2F98%2F8e%2F11949794079078e98eo.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955388&di=6ad764b30878c540a0a8843d56285566&imgtype=0&src=http%3A%2F%2Fpic.ilitu.com%2Fy2%2F23_34383397241.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497241008837&di=05377a54c182d5993441e311355a104c&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D1034135176%2C4215732088%26fm%3D214%26gp%3D0.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955387&di=d5130fadbd15750b3e9196ca1b3edbff&imgtype=0&src=http%3A%2F%2Fwww.bz55.com%2Fuploads%2Fallimg%2F110919%2F0S92V163-2.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955387&di=d2eda302329048f6b860316abae3ad12&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1308%2F15%2Fc1%2F24493956_1376530423419.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955386&di=88a8be9178d3218f663591ffce07ce6f&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F27%2F25%2F80N58PICwPx_1024.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955386&di=d0247ead4b9a7f1e0c1e587c162cd7c8&imgtype=0&src=http%3A%2F%2Fpic.ilitu.com%2Fy2%2F492_33122987002.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955385&di=17cb718044740e3d113b9ec77f48bb5c&imgtype=0&src=http%3A%2F%2Fwww.bz55.com%2Fuploads%2Fallimg%2F150719%2F139-150G9151230.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955384&di=0a563153f458de0854e5b78cf569bf0e&imgtype=0&src=http%3A%2F%2Fpic.ilitu.com%2Fy2%2F138_24622057251.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497240955383&di=d1588374fc3f873de3c35a6ecc2c4eff&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F17%2F95%2F19X58PIC8Y5_1024.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497241035251&di=3035e01f8ad342d086212d29ba6b0efb&imgtype=0&src=http%3A%2F%2Fwww.bz55.com%2Fuploads%2Fallimg%2F150326%2F140-150326103026.jpg",
                                          @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497241035251&di=2ac1d0e9e222e63490f7f1ba21bfcbb2&imgtype=0&src=http%3A%2F%2Fimg17.3lian.com%2Fd%2Ffile%2F201703%2F01%2Fd13c2c900e52fbb9e3703abb1c29da77.jpg",];
    
    NSArray <NSURL *>*urlMArray = [WZRemoteImageBrowseController fetchUrlArrayAccordingStringArray:imageArray];
    [WZRemoteImageBrowseController showRemoteImagesWithURLArray:urlMArray loactedVC:self];
}

#pragma mark - WZProtocolMediaAsset 选图片回调

- (void)fetchAssets:(NSArray <WZMediaAsset *> *)assets {
    NSLog(@"%@",assets);
}

- (void)fetchImages:(NSArray <UIImage *> *)images {
    NSLog(@"%@",images);
}


@end
