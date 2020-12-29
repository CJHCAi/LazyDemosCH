//
//  HKUpdateResumeHeadImgCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditResumeBlock)(void);

@interface HKUpdateResumeHeadImgCell : UITableViewCell

@property (nonatomic, strong) NSString *headImg;

@property (nonatomic, copy) EditResumeBlock block;

@end
