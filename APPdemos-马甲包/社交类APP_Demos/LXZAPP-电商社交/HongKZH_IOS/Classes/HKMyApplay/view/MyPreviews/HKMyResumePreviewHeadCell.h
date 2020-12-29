//
//  HKMyResumePreviewHeadCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyResumePreview.h"
typedef void(^ResumePreviewWatchAnnexBlock)(void);
typedef void(^ResumePreviewWatchVideoBlock)(void);
@interface HKMyResumePreviewHeadCell : UITableViewCell

@property (nonatomic, strong) HKMyResumePreviewData *myResumePreviewData;
@property (nonatomic, copy) ResumePreviewWatchAnnexBlock watchAnnexBlcok;
@property (nonatomic, copy) ResumePreviewWatchVideoBlock watchVideoBlock;
@end
