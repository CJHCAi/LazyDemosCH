//
//  WZPhotoCatalogueController.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/21.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMediaAssetBaseCell.h"
@class WZMediaAssetCollection;
@protocol WZProtocolMediaAsset;

/**
 *  图片目录
 */
@interface WZPhotoCatalogueCell : WZMediaAssetBaseCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) WZMediaAssetCollection *mediaAssetCollection;
@property (nonatomic, strong) void (^clickedBlock)();

@end

@interface WZPhotoCatalogueController : UIViewController

+ (void)showPickerWithPresentedController:(UIViewController <WZProtocolMediaAsset>*)presentedController;

@end
