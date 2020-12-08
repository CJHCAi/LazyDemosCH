//
//  ARNetCommand.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARNetCommand : NSObject

@property (nonatomic,strong) NSArray *keywordsArr;

+(UIImage *)downloadImageWithImgStr:(NSString *)imgUrlStr placeholderImageStr:(NSString *)placeholderImageStr imageView:(UIImageView *)imageView;
//解析，返回模型数组
+ (NSArray *)netRequestReturnArray:(NSString *)urlStr param:(NSDictionary *)param valueKey:(NSString *)valueKey;

//下载图片到缓存
+ (void)downloadAndStoredImage:(NSString *)imgUrlStr imageKey:(NSString *)imageKey;

@end
