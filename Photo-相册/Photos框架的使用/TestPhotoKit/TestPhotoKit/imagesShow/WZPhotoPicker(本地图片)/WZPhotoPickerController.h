//
//  WZPhotoPickerController.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/19.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMediaFetcher.h"

/**
 *  图片挑选
 */
@interface WZPhotoPickerController : UIViewController

@property (nonatomic, weak) id<WZProtocolMediaAsset> delegate;
@property (nonatomic, strong) NSArray <WZMediaAsset *>* mediaAssetArray;
@property (nonatomic, assign) NSUInteger restrictNumber;

@end
