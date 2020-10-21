//
//  WZAssetBrowseController.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseController.h"
#import "WZAssetBrowseNavigationView.h"
#import "WZAssetBrowseToolView.h"

@interface WZAssetBrowseController ()

@property (nonatomic, strong) WZAssetBrowseNavigationView *navigationView;//顶部导航条
@property (nonatomic, strong) WZAssetBrowseToolView *toolView;//底部工具条

@end

@implementation WZAssetBrowseController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - CreateViews
- (void)createViews {
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.toolView];
    [self caculateSelected];
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark - WZProtocolAssetBrowseNaviagtion
- (void)backAction {
    if ([self.imagesBrowseDelegate respondsToSelector:@selector(backAction)]) {
        [self.imagesBrowseDelegate backAction];
    }
    [self dismissViewControllerAnimated:true completion:^{}];
}

- (void)selectedAction {
    if ([self overloadJudgement] && !self.currentMediaAsset.selected) {
        return;
    }
    
    self.currentMediaAsset.selected = !self.currentMediaAsset.selected;
    _navigationView.selectedButton.selected = self.currentMediaAsset.selected;
    [self caculateSelected];
}

#pragma mark - WZProtocolAssetBrowseTool
- (void)selectedOrigionAction {
    self.currentMediaAsset.origion = !self.currentMediaAsset.origion;
    self.toolView.selectedButtonClear.selected = self.currentMediaAsset.origion;
    [self fetchOrigion];
}

- (void)completeAction {
    [self dismissViewControllerAnimated:false completion:^{
        if ([self.imagesBrowseDelegate respondsToSelector:@selector(send)]) {
            [self.imagesBrowseDelegate send];
        }
    }];
}

#pragma mark - Match image
- (void)matchThumnailImageWith:(WZImageContainerController *)VC {
    [super matchThumnailImageWith:VC];
    
    NSUInteger index = VC.index;
    if (index < self.mediaAssetArray.count ) {
        WZMediaAsset *asset = self.mediaAssetArray[index];
        if (asset.imageThumbnail) {
            [VC matchingPicture:asset.imageThumbnail];
        } else {
            [WZMediaFetcher fetchThumbnailWithAsset:asset.asset synchronous:false handler:^(UIImage *thumbnail) {
                asset.imageThumbnail = thumbnail;
                [VC matchingPicture:asset.imageThumbnail];
            }];
        }
    }
}

- (void)matchClearImageWith:(WZImageContainerController *)VC {
    [super matchClearImageWith:VC];
    
    NSUInteger index = VC.index;
    WZMediaAsset *asset = nil;
    if (index < self.mediaAssetArray.count ) {
        asset = self.mediaAssetArray[index];
        
        if (asset.clearPath || asset.imageClear) {
            if (asset.imageClear) {
                [VC matchingPicture:asset.imageClear];
                [self caculateImageDataWithImage:asset.imageClear];
            } else {
                UIImage *image = [UIImage imageWithContentsOfFile:asset.clearPath];
                [VC matchingPicture:image];
                [self caculateImageDataWithImage:image];
            }
           
        }  else if (asset.asset) {
            //根据 PHAsset callback
            //block回调可能会引起图片紊乱(重用)  请求前先将之前的request cancel掉
            
            [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID];
            [[PHImageManager defaultManager] cancelImageRequest:_imageDataRequestID];
            
            if (asset.origion) {
                _imageRequestID = [WZMediaFetcher fetchOrigionWith:asset.asset synchronous:false handler:^(UIImage *origion) {
                    [VC matchingPicture:origion];
                }];
            } else {
                //渲染成本太高 不选源图
                _imageRequestID = [WZMediaFetcher fetchImageWithAsset:asset.asset costumSize:WZMEDIAASSET_CUSTOMSIZE synchronous:false handler:^(UIImage *image) {
                    [VC matchingPicture:image];
                }];
            }
            
            //数据计算
            _imageDataRequestID = [WZMediaFetcher fetchImageWithAsset:asset.asset synchronous:false handler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self caculateImageDataWithData:imageData];
            }];
        }
    }
    
    {
        //配置其他的属性
        self.currentMediaAsset = asset;
        self.currentContainerVC = VC;
        self.navigationView.selectedButton.selected = self.currentMediaAsset.selected;
        self.toolView.selectedButtonClear.selected = self.currentMediaAsset.origion;
        self.navigationView.titleLabel.text = [NSString stringWithFormat:@"当前页面ID:%ld", index];
       
    }
}

#pragma mark - private method
- (void)caculateSelected {
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.mediaAssetArray) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    self.toolView.restrictNumber(restrictNumber);
}

- (BOOL)overloadJudgement {
    if (self.restrictNumber == 0) {
        return false;
    }
    
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.mediaAssetArray) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    
    if (self.restrictNumber <= restrictNumber) {
        return true;
    }
    
    return false;
}

- (void)caculateImageDataWithImage:(UIImage *)image {
    if (!image) {
        return;
    }
    NSData *data = UIImagePNGRepresentation(image);
    [self caculateImageDataWithData:data];
}

- (void)caculateImageDataWithData:(NSData *)data {
    self.toolView.fetchClearInfo([NSString stringWithFormat:@"%.3lf M", data.length / 1000.0 / 1000.0]);
}

- (void)fetchOrigion {
    if (self.currentMediaAsset.origion) {
        [WZMediaFetcher fetchOrigionWith:self.currentMediaAsset.asset synchronous:true handler:^(UIImage *origion) {
            [self.currentContainerVC matchingPicture:origion];
        }];
    }
}

#pragma mark - Accessor
- (WZAssetBrowseNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [WZAssetBrowseNavigationView customAssetBrowseNavigationWithDelegate:(id<WZProtocolAssetBrowseNaviagtion>)self];
    }
    return _navigationView;
}

- (WZAssetBrowseToolView *)toolView {
    if (!_toolView) {
        _toolView = [WZAssetBrowseToolView customAssetBrowseToolWithDelegate:(id<WZProtocolAssetBrowseTool>)self];
    }
    return _toolView;
}

@end
