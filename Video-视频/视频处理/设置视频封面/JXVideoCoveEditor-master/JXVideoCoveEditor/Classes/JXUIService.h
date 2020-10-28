//
//  JXUIService.h
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@class JXVideoImage;
static NSString  *const kVideoCellIdentifier = @"cell";
static CGFloat const KeyframePickerViewCellWidth = 67;

@interface JXUIService : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
/** asset*/
@property (nonatomic, strong) AVAsset *asset;

- (void)loadData:(AVAsset *)asset callBlock:(void(^)())callBlock;

/** 滚动block*/
@property (nonatomic, copy)void(^scrollDidBlock)(CMTime);


@end
