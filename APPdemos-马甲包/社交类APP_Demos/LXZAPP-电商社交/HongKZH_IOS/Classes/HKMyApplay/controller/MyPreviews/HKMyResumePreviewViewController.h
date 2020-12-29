//
//  HKMyResumePreviewViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HKMyResumePreviewViewController : HK_BaseView
@property (nonatomic, strong) NSString *resumeId;
@property (nonatomic, copy) NSString *recruitId;    //候选人需要传
@property (nonatomic, assign) NSInteger source; //1.简历预览2.搜索简历3.候选人
@end
