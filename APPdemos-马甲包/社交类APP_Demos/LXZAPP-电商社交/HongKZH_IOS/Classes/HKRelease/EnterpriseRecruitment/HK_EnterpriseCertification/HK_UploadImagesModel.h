//
//  HK_UploadImagesModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    一个地址上传多个参数的图片
 */
@interface HK_UploadImagesModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *uploadKey;
@property (nonatomic, copy) NSString *fileName;
@end
