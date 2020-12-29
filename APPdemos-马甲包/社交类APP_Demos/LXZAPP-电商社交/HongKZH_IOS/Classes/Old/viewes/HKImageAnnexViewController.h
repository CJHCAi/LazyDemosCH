//
//  HKImageAnnexViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKMyResumePreview.h"
@interface HKImageAnnexViewController : HK_BaseView

@property (nonatomic, strong) NSArray<HKMyResumePreviewImgs *> *imgs;

@end


@interface HKImageAnnexCollectionViewCell :UICollectionViewCell

@property (nonatomic, strong) HKMyResumePreviewImgs *imageData;

@property (nonatomic, weak) UIImageView *imgView;


@end
