//
//  HKDetailsPageViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HJTabViewController.h"
#import "GetMediaAdvAdvByIdRespone.h"
@interface HKDetailsPageViewController : HJTabViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdProducts *productM;
@property (nonatomic, copy)NSString *productId;

@property (nonatomic, copy)NSString *provinceId;
@end
