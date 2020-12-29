//
//  HK_CardsCertificationViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HK_UploadImagesModel.h"
/*
    企业验证第二步--拍身份证和营业执照
 */
@interface HK_CardsCertificationViewController : HK_BaseView
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, weak) NSMutableDictionary<NSString *, HK_UploadImagesModel *> *images;
@end
