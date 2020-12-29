//
//  HKUserContentViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HK_BaseInfoResponse.h"

typedef void(^UploadSuccessBlock)(void);

@interface HKUserContentViewController : HK_BaseView

@property (nonatomic, weak) HK_UserRecruitData *data;

@property (nonatomic, copy) UploadSuccessBlock uploadSuccessBlock;

@end
