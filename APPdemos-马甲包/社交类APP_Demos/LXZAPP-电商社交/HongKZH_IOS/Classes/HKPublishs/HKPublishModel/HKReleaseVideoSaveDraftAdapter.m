//
//  HKReleaseVideoSaveDraftAdapter.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseVideoSaveDraftAdapter.h"
#import "SaveMediaTool.h"
#import "HKObject2JsonTool.h"
#import "HK_UserProductList.h"
@interface HKReleaseVideoSaveDraftAdapter()

@end

@implementation HKReleaseVideoSaveDraftAdapter

+ (HKReleaseVideoSaveDraft *)convertParam2SaveDraft {
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    HKReleaseVideoSaveDraft *draft = [[HKReleaseVideoSaveDraft alloc] init];
    //保存封面到本地,如果保存成功,封装数据
    NSString *imgName = [NSUUID UUID].UUIDString;
    BOOL success = [SaveMediaTool saveImgSrcWithImageName:imgName image:param.coverImgSrc];
    if(success) {
        draft.coverImgSrc = imgName;
    }
    //分类json
    NSString *categroyJSON = [HKObject2JsonTool getJsonFromObj:param.category];
    draft.categroyJSON = categroyJSON;
    //日期 yyyy.MM.dd hh:mm:ss
    NSDate *curDate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    NSString *curTime = [dateFormatter stringFromDate: curDate];
    draft.curTime = curTime;
    //视频地址
    draft.filePath = param.filePath;
    //图片地址数组转换的json
    NSMutableArray *imgsArray = param.photographyImages;
    if ([imgsArray count] > 0) {
        NSMutableArray *imgsNames = [NSMutableArray array];
        for(UIImage *image in imgsArray) {
            NSString *imgName = [NSUUID UUID].UUIDString;
            BOOL success = [SaveMediaTool saveImgSrcWithImageName:imgName image:image];
            if(success) {
                [imgsNames addObject:imgName];
            }
        }
        NSString *photosJSON = [imgsNames mj_JSONString];
        draft.photosJSON = photosJSON;
    }
    //参数json
    draft.paramDictJSON = [[param dataDict] mj_JSONString];
    //发布类型
    draft.publishType = param.publishType;
    //企业ID
    draft.userEnterpriseId = param.userEnterpriseId;
    //products转换的json
    NSMutableArray *products = param.products;
    NSMutableArray *productDicts = [NSMutableArray array];
    for (id obj in products) {
        NSDictionary *dict = [HKObject2JsonTool getObjectData:obj];
        [productDicts addObject:dict];
    }
    draft.productsJSON = [productDicts mj_JSONString];
    //展位个数
    draft.boothCount = param.boothCount;
    
    return draft;
}

+ (void)convertDraft2Param:(HKReleaseVideoSaveDraft *)draft {
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    //获取封面coverImgSrc
    param.coverImgSrc = [SaveMediaTool getImgWithImageName:draft.coverImgSrc];
    //获取分类
    NSDictionary *dict = [draft.categroyJSON mj_JSONObject];
    HK_BaseAllCategorys *category = [HK_BaseAllCategorys mj_objectWithKeyValues:dict];
    param.category = category;
    //视频地址
    param.filePath = draft.filePath;
    //photos
    NSMutableArray *photoUrls = [draft.photosJSON mj_JSONObject];
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *url in photoUrls) {
        UIImage *photo = [SaveMediaTool getImgWithImageName:url];
        [photos addObject:photo];
    }
    param.photographyImages = photos;
    //参数dict
    param.dict = [NSMutableDictionary dictionaryWithDictionary:[draft.paramDictJSON mj_JSONObject]];
    //发布类型
    param.publishType = draft.publishType;
    //企业ID
    param.userEnterpriseId = draft.userEnterpriseId;
    //展位个数
    param.boothCount = draft.boothCount;
    //products
    NSMutableArray *products = [NSMutableArray array];
    NSMutableArray *tempProducts = [draft.productsJSON mj_JSONObject];
    for (NSDictionary *dict in tempProducts) {
        HKUserProduct *product = [HKUserProduct mj_objectWithKeyValues:dict];
        [products addObject:product];
    }
    param.products = products;
}


@end
