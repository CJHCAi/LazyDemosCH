//
//  HKReleaseVideoParam.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseVideoParam.h"
#import "NSData+EasyExtend.h"
#import "HK_UploadImagesModel.h"
#import "HKUpdataFromDataModel.h"
#import "HKPublichVideoUpdataModel.h"
#import "HKDateTool.h"
#import "UrlConst.h"
#import "HK_UserProductList.h"
@interface HKReleaseVideoParam()<NSCopying,NSMutableCopying>

@end

@implementation HKReleaseVideoParam

#pragma mark 单例
static HKReleaseVideoParam* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [HKReleaseVideoParam shareInstance] ;
}

-(id) copyWithZone:(NSZone *)zone
{
    return [HKReleaseVideoParam shareInstance] ;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [HKReleaseVideoParam shareInstance] ;
}

- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

+(void)setObject:(id)object key:(NSString *)key {
    HKReleaseVideoParam *releaseParam = [self shareInstance];
    [releaseParam.dict setObject:object forKey:key];
}

+(void)clearParam {
    HKReleaseVideoParam *releaseParam = [self shareInstance];
    releaseParam.filePath = nil;
    releaseParam.coverImgSrc = nil;
    releaseParam.category = nil;
    releaseParam.userEnterpriseId = nil;
    releaseParam.photographyImages = nil;
    [releaseParam.dict removeAllObjects];
}

//验证数据
- (void)validateDatapublishType:(ENUM_PublishType)publishType success:(void(^)(void))successBlock failure:(void(^)(NSString *tip))failureBlock{
    if (self.publishType == ENUM_PublishTypeEditResume ||
        self.publishType == ENUM_PublishTypeEditRecruitment) {
        
        
    } else {
        NSString *title = [self.dict objectForKey:@"title"];
        if (title == nil || [title isEqualToString:@""]) {
            failureBlock(@"标题不能为空");
            return;
        }
    }
    
    if (self.publishType == ENUM_PublishTypePublic ||
        self.publishType == ENUM_PublishTypePhotography) {
        NSString *remark = [self.dict objectForKey:@"remarks"];
        if (remark == nil || [remark isEqualToString:@""]) {
            failureBlock(@"内容不能为空");
            return;
        }
    } else if(self.publishType == ENUM_PublishTypeMarry) {
        NSString *note = [self.dict objectForKey:@"note"];
        if (note == nil || [note isEqualToString:@""]) {
            failureBlock(@"内容不能为空");
            return;
        }
    }
    successBlock();
}

- (NSMutableArray *)imagesData {
    NSMutableArray<NSMutableArray<HK_UploadImagesModel *> *> *images = [NSMutableArray array];
    NSMutableArray<HK_UploadImagesModel *> *coverImgArray = [NSMutableArray array];
    if (self.publishType == ENUM_PublishTypeEditResume ||
        self.publishType == ENUM_PublishTypeEditRecruitment) {
        
    }
    else{
        //封面图片
        HK_UploadImagesModel *imageModel = [[HK_UploadImagesModel alloc] init];
        NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
        imageModel.fileName = imageName;
        imageModel.image = self.coverImgSrc;
        imageModel.uploadKey = @"coverImgSrc";
        [coverImgArray addObject:imageModel];
        [images addObject:coverImgArray];
    }
    
    //摄影添加照片
    if ([self.photographyImages count] > 0) {
        NSMutableArray<HK_UploadImagesModel *> *photographyImgArray = [NSMutableArray array];
        for (UIImage *photo in self.photographyImages) {
            HK_UploadImagesModel *imageModel = [[HK_UploadImagesModel alloc] init];
            NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
            imageModel.fileName = imageName;
            imageModel.image = photo;
            imageModel.uploadKey = @"photos";
            [photographyImgArray addObject:imageModel];
        }
        [images addObject:photographyImgArray];
    }
    return images;
}
-(NSDictionary*)dataParamDict:(NSString*)imgSrc coverImgSrc:(NSString*)coverImgSrc type:(ENUM_PublishType)type products:(NSMutableArray*)products{
        if (products.count>0) {
            for (HKUserProduct*product in products) {
                HKUpdataFromDataModel*model = [[HKUpdataFromDataModel alloc]init];
                model.vaule = product.productId;
                model.name = @"products";
                
                [self.dataArray addObject:model];
            }
        }
    if (self.coverImgSrc) {
        HKUpdataFromDataModel*model = [[HKUpdataFromDataModel alloc]init];
        model.type = 1;
        model.image = self.coverImgSrc;
        model.name = @"coverImgSrc";
        [self.dataArray addObject:model];
    }
        if (self.photographyImages.count>0) {
            for (UIImage*image in self.photographyImages) {
                HKUpdataFromDataModel*model = [[HKUpdataFromDataModel alloc]init];
                model.image = image;
                model.name = @"photos";
                model.type = 1;
                model.mimeType = @"jpeg";
                model.vaule = [NSString stringWithFormat:@"%d",[HKDateTool getCurrentTime13]];
                [self.dataArray addObject:model];
            }
        }

    if ([self.dict[@"tagId"]isKindOfClass:[NSArray class]]&&[self.dict[@"tagId"]count]>0) {
        for (NSString*key in @[@"tagId",@"tagType",@"tagName",@"x",@"y",@"orientation"]) {
            for (NSString*str in self.dict[key]) {
                HKUpdataFromDataModel*model = [[HKUpdataFromDataModel alloc]init];
                model.vaule = str;
                model.name = key;
                [self.dataArray addObject:model];
            }
        }
        
    }
    HKPublichVideoUpdataModel*model = [HKPublichVideoUpdataModel mj_objectWithKeyValues:self.dict];
    if (imgSrc.length>0) {
        model.imgSrc = imgSrc;
    }
    if (coverImgSrc.length>0) {
        model.coverImgSrc = coverImgSrc;
    }
    model.loginUid = HKUSERLOGINID;
    NSDictionary*dict = [model mj_keyValues];
    
    return dict;
}

- (NSMutableDictionary *)dataDict {
    return  self.dict;
}
-(void)setCoverImgSrc:(UIImage *)coverImgSrc{
    _coverImgSrc = coverImgSrc;
    NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@_%d",[value MD5String],[HKDateTool getCurrentTime13]]];
   self.coverImgSrcPath = [self saveImage:coverImgSrc name:imageName];
}
-(NSString*)saveImage:(UIImage *)image name:(NSString*)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    NSString *filePath = [self getChat:@"" withType:1];
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        
        if (!(isDir && existed)) {
            // 在Document目录下创建一个archiver目录
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filePath2  = [NSString stringWithFormat:@"%@/%@",filePath,name]; // 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath2   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        DLog(@"保存成功");
    }
    return filePath2;
}
-(NSString*)getChat:(NSString*)name withType:(int)chatType{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* nameF = @"video";
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:nameF];
  
    return filePath;
    
}
-(NSMutableArray *)products{
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
-(void)setPublishType:(ENUM_PublishType)publishType{
    _publishType = publishType;
    switch (publishType) {
        case ENUM_PublishTypePublic:
        {
            self.updataUrl = get_releasePublic;
        }
            break;
        case ENUM_PublishTypeResume:
        {
            self.updataUrl = get_updateReleaseResume;
        }
            break;
        case ENUM_PublishTypeRecruit:
        {
            self.updataUrl = get_releaseRecruit;
        }
            break;
        case ENUM_PublishTypePhotography:
        {
            self.updataUrl = get_releasePhotography;
        }
            break;
        case ENUM_PublishTypeMarry:
        {
            self.updataUrl = get_releaseMarry;
        }
            break;
        case ENUM_PublishTypeEditResume:
        {
            self.updataUrl = get_releaseResume;
        }
            break;
        case ENUM_PublishTypeEditRecruitment:
        {
            self.updataUrl = get_editResume;
        }
            break;
        default:
            break;
    }
}

@end

