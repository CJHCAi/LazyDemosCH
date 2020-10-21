//
//  WZImageBrowseController.h
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZImageContainerController.h"
#import "UIImageView+WebCache.h"

@protocol WZProtocolImageBrowse <NSObject>

- (void)backAction;//返回代理事件
- (void)send;//发送代理事件

@end

//图片浏览容器控制器
@interface WZImageBrowseController : UIPageViewController

@property (nonatomic, strong) id<WZProtocolImageBrowse> imagesBrowseDelegate;//代理
@property (nonatomic, strong) NSArray <WZMediaAsset *> *mediaAssetArray;//选中的mdeiaAsset集合
@property (nonatomic, strong) NSArray<WZImageContainerController *> *imageContainersReuseableArray;//图片容器（复用）
@property (nonatomic, strong) WZImageContainerController *currentContainerVC;//当前的图片容器
@property (nonatomic, assign) NSInteger currentIndex;//当前图片的角标
@property (nonatomic, assign) NSInteger numberOfIndexs;//图片的角标极值
@property (nonatomic, assign) NSUInteger restrictNumber;//限制选图数目 ＝0时无选图限制
@property (nonatomic, strong) WZMediaAsset *currentMediaAsset;//当前集合

- (void)showInIndex:(NSInteger)index animated:(BOOL)animated;//控制器定位
- (void)matchThumnailImageWith:(WZImageContainerController *)VC;//控制器缩略图匹配
- (void)matchClearImageWith:(WZImageContainerController *)VC;//控制器上清晰图匹配

@end
