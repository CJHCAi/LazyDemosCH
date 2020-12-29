//
//  HKReleaseVideoParam.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseAllCategorys.h"

typedef enum {
    ENUM_PublishTypePublic = 0,             //发布公共模块
    ENUM_PublishTypeRecruit,                //发布企业招聘
    ENUM_PublishTypeResume,                 //发布个人简历
    ENUM_PublishTypePhotography,            //发布摄影
    ENUM_PublishTypeMarry,                   //发布征婚交友
    ENUM_PublishTypeEditResume,              //编辑视频简历
    ENUM_PublishTypeEditRecruitment              //编辑招聘
} ENUM_PublishType;

@interface HKReleaseVideoParam : NSObject

@property (nonatomic, strong) NSString *filePath;       //视频路径

@property (nonatomic, copy)NSString *coverImgSrcPath;
@property (nonatomic, strong) UIImage *coverImgSrc;     //封面

@property (nonatomic, strong) NSMutableArray *photographyImages;    //附件

@property (nonatomic, strong) NSMutableArray *products;     //商品

@property (nonatomic, assign) NSInteger boothCount; //展位个数

@property (nonatomic, strong) HK_BaseAllCategorys *category;

@property (nonatomic, strong) NSString *userEnterpriseId;

@property (nonatomic, assign) ENUM_PublishType publishType;    //发布类型

@property (nonatomic, strong) NSMutableDictionary *dict;

+(instancetype) shareInstance;

+(void)setObject:(id)object key:(NSString *)key;

+(void)clearParam;

- (NSMutableArray *)imagesData;

- (void)validateDatapublishType:(ENUM_PublishType)publishType success:(void(^)(void))successBlock failure:(void(^)(NSString *tip))failureBlock;

- (NSMutableDictionary *)dataDict;

@property (nonatomic, strong)NSMutableArray *dataArray;
-(NSDictionary*)dataParamDict:(NSString*)imgSrc coverImgSrc:(NSString*)coverImgSrc type:(ENUM_PublishType)type products:(NSMutableArray*)products;

@property (nonatomic, copy)NSString *updataUrl;

@end
