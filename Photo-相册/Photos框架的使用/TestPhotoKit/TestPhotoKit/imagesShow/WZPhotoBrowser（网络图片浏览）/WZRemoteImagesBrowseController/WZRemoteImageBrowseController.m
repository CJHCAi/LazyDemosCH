//
//  WZRemoteImageBrowseController.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZRemoteImageBrowseController.h"
#import "WZToast.h"

@interface WZRemoteImageBrowseController ()

@property (nonatomic, strong) WZRemoteImageNavigationView *navigationView;

@end

@implementation WZRemoteImageBrowseController

//会过滤部分字符串
+ (NSArray <NSURL *>*)fetchUrlArrayAccordingStringArray:(NSArray <NSString *>*)stringArray {
    NSMutableArray *urlMArray = [NSMutableArray array];
    for (NSString *urlStr in stringArray) {
        if ([urlStr isKindOfClass:[NSString class]] && urlStr.length) {
            NSURL *url = [NSURL URLWithString:urlStr];
            if ([url isKindOfClass:[NSURL class]]) {
                [urlMArray addObject:url];
            }
        }
    }
    return urlMArray;
}

#pragma mark - Initialize
+ (void)showRemoteImagesWithURLArray:(NSArray <NSURL *>*)urlArray loactedVC:(UIViewController *)locatedVC {
    if (!urlArray
        || !locatedVC
        || ![urlArray isKindOfClass:[NSArray class]]
        || ![locatedVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    NSMutableArray *imagesMArray = [NSMutableArray array];
    
    SDWebImageDownloader *sdDownloader = [SDWebImageDownloader sharedDownloader];
    [sdDownloader setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    for (int i = 0; i < urlArray.count; i++) {
        WZMediaAsset *asset = [[WZMediaAsset alloc] init];
        asset.remoteMediaURL = urlArray[i];
        asset.imageThumbnail = [UIImage imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [imagesMArray addObject:asset];
        
        //使用了url缓存
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:asset.remoteMediaURL];
        if (key) {
            UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            if (cacheImage) {
                asset.imageClear = cacheImage;
                asset.imageThumbnail = cacheImage;
            }
            NSLog(@"远程图片缓存Path:%@", [[SDImageCache sharedImageCache] defaultCachePathForKey:key]);
        }
    }
    
    if (imagesMArray.count) {
        WZRemoteImageBrowseController *VC = [[WZRemoteImageBrowseController alloc] init];
        VC.imagesBrowseDelegate = (id<WZProtocolImageBrowse>)locatedVC;
        VC.mediaAssetArray = imagesMArray;
        
        VC.restrictNumber = 9;//控制选中图片的数目
        [VC showInIndex:0 animated:true];
        [locatedVC presentViewController:VC animated:true completion:^{}];
    }
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)createViews {
    [self.view addSubview:self.navigationView];
    [self caculateSelected];
}

#pragma mark - Match image
- (void)matchThumnailImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.index;
    if (index >= self.mediaAssetArray.count) {
        return;
    }
    
    VC.progress.hidden = true;//隐藏加载视图
    if (index < self.mediaAssetArray.count) {
        WZMediaAsset *asset = self.mediaAssetArray[index];
        NSAssert(asset.imageThumbnail, @"请配置默认图！");
        if (asset.imageThumbnail) {
            [VC matchingPicture:asset.imageThumbnail];
        }
    }
}

- (void)matchClearImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.index;
    if (index >= self.mediaAssetArray.count) {
        return;
    }
    VC.progress.hidden = true;
    WZMediaAsset *asset = nil;
    if (index < self.mediaAssetArray.count ) {
        asset = self.mediaAssetArray[index];
        NSAssert(asset.remoteMediaURL, @"却少媒体URL！");
        
        if (asset.clearPath) {
            UIImage *image = [UIImage imageWithContentsOfFile:asset.clearPath];
            if (image) {
                [VC matchingPicture:image];
                return;
            }
        }
        if (asset.imageClear) {
            [VC matchingPicture:asset.imageClear];
        } else if (asset.remoteMediaURL) {
            
            [self.mediumImageView sd_cancelCurrentImageLoad];
            //复位状态
            [VC.progress setProgressRate:0];
             VC.progress.hidden = false;
            if ([asset.remoteMediaURL isKindOfClass:[NSURL class]]) {
                
                [self.mediumImageView sd_setImageWithPreviousCachedImageWithURL:asset.remoteMediaURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    /*
                     这个因为NSHTTPURLResponse中
                     Accept-Encoding为gzip造成的
                     当遇到Accept-Encoding为gzip时，expectedsize会变为-1不确定的大小
                     此时在sdwebimage中expectedsize判断小于0，就会赋值为0
                     所以如果确定文件的大小时，可以将Accept-Encoding修改成非gzip的就可以获取需要的文件大小了
                     */
                    if (expectedSize > 0) {
                        [VC.progress setProgressRate:receivedSize / (expectedSize * 1.0)];
                    }
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    VC.progress.hidden = true;
                    if (error) {
                        //显示下载失败的图片
                        [WZToast toastWithContent:[NSString stringWithFormat:@"图片下载失败:页面id为 %ld", VC.index]];
                    } else {
                        if (image) {
                            asset.imageThumbnail = image;
                            asset.imageClear = image;
                            [VC matchingPicture:image];
                        }
                    }
                }];
            } else {
                [WZToast toastWithContent:@"图片url错误"];
            }
        } else {
            [WZToast toastWithContent:@"匹配不到图片资源"];
        }
    }
    
    self.currentMediaAsset = asset;
    self.currentContainerVC = VC;
    self.navigationView.titleLabel.text = [NSString stringWithFormat:@"当前页面ID:%ld", index];
}

/*
 HTTP Header中
 Accept-Encoding 是浏览器发给服务器,声明浏览器支持的编码类型的
 常见的有
 Accept-Encoding: compress, gzip　　　　　　　　　　　　 //支持compress 和gzip类型
 Accept-Encoding:　　　　　　　　　　　　　　　　　　　     //默认是identity
 Accept-Encoding: *　　　　　　　　　　　　　　　　　　　　 //支持所有类型
 Accept-Encoding: compress;q=0.5, gzip;q=1.0         //按顺序支持 gzip , compress
 Accept-Encoding: gzip;q=1.0, identity; q=0.5, *;q=0 // 按顺序支持 gzip , identity
 
 服务器返回的对应的类型编码header是 content-encoding
 服务器处理accept-encoding的规则如下所示
 　　1. 如果服务器可以返回定义在Accept-Encoding 中的任何一种Encoding类型, 那么处理成功(除非q的值等于0, 等于0代表不可接受)
 　　2. * 代表任意一种Encoding类型 (除了在Accept-Encoding中显示定义的类型)
 　　3.如果有多个Encoding同时匹配, 按照q值顺序排列
 　　4. identity总是可被接受的encoding类型(除非显示的标记这个类型q=0) , 如果Accept-Encoding的值是空 那么只有identity是会被接受的类型
 如果Accept-Encoding中的所有类型服务器都没发返回, 那么应该返回406错误给客户端
 如果request中没有Accept-Encoding 那么服务器会假设所有的Encoding都是可以被接受的,
 如果Accept-Encoding中有identity  那么应该优先返回identity (除非有q值的定义,或者你认为另外一种类型是更有意义的)
 注意:
 如果服务器不支持identity 并且浏览器没有发送Accept-Encoding,那么服务器应该倾向于使用HTTP1.0中的 "gzip" and "compress" , 服务器可能按照客户端类型 发送更适合的encoding类型
 大部分HTTP1.0的客户端无法处理q值
 */

#pragma mark - Accessor
- (UIImageView *)mediumImageView {
    if (!_mediumImageView) {
        _mediumImageView = [[UIImageView alloc] init];
    }
    return _mediumImageView;
}

- (WZRemoteImageNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [WZRemoteImageNavigationView customAssetBrowseNavigationWithDelegate:(id<WZProtocolAssetBrowseNaviagtion>)self];
    }
    return _navigationView;
}
@end

