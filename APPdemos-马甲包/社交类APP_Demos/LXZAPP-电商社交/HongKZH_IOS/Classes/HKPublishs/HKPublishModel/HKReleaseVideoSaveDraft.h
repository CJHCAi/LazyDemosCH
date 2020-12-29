//
//  HKReleaseVideoSaveDraft.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    数据库保存数据
 */
@interface HKReleaseVideoSaveDraft : NSObject

@property (nonatomic, strong) NSString *coverImgSrc;    //封面图片名字

@property (nonatomic, strong) NSString *categroyJSON;   //分类的json

@property (nonatomic, strong) NSString *curTime;    //日期 yyyy.MM.dd hh:mm:ss

@property (nonatomic, strong) NSString *filePath;   //视频地址

@property (nonatomic, strong) NSString *photosJSON;     //图片地址数组转换的json

@property (nonatomic, strong) NSString *paramDictJSON;  //参数json

@property (nonatomic, assign) NSInteger publishType;    //发布类型

@property (nonatomic, strong) NSString *userEnterpriseId;   //企业ID

@property (nonatomic, strong) NSString *productsJSON;   //products转换的json

@property (nonatomic, assign) NSInteger boothCount; //展位个数

@end
