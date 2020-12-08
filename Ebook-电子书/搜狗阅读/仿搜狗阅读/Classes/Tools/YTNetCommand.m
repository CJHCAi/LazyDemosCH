//
//  YTNetCommand.m
//  每日烹
//
//  Created by Mac on 16/4/29.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTNetCommand.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "YTsearchKeyWords.h"

@interface NSObject()


@end

@implementation YTNetCommand
//这个方法暂时没用
//+(void)httpRequest:(NSString *)urlStr param:(NSDictionary *)param apikey:(NSString *)apikey{
//
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
//
//
//    [manager GET :urlStr parameters:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//      
//    //NSLog(@"%@", responseObject);
//        
//        NSArray *MenuItemArr = [YTMenuItem mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"tngou"]];
//        for (YTMenuItem *itm in MenuItemArr) {
//          //  NSLog(@"%@",itm.message);
//      
//        }
//    
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"%@", error);
//    
//    }];
//}
//  下载图片
+(UIImage *)downloadImageWithImgStr:(NSString *)imgUrlStr placeholderImageStr:(NSString *)placeholderImageStr imageView:(UIImageView *)imageView{

    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:placeholderImageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      //  NSLog(@"cacheType:%ld",(long)cacheType);
      //  NSLog(@"imageurl:%@",imageURL);
    }];

    UIImage *img = imageView.image;
    return img;
    
}

+ (void)downloadAndStoredImage:(NSString *)imgUrlStr imageKey:(NSString *)imageKey{
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:nil
                        options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //进度
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache]storeImage:imgView.image forKey:imageKey];
        NSLog(@"图片存储成功");
    }];

}

+ (void)downloadTxtfileWithUrl:(NSString *)urlStr{
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
    //    NSLog(@"文件的路径%@", location.path);
        
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //    NSLog(@"%@", cacheDir);
        /**
         FileAtPath：要解压缩的文件
         Destination: 要解压缩到的路径
         */
        [SSZipArchive unzipFileAtPath:location.path toDestination:cacheDir];
        
    }] resume];


}


+ (NSArray *)netRequestReturnArray:(NSString *)urlStr param:(NSDictionary *)param valueKey:(NSString *)valueKey{
   __block NSArray *array = [NSArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET :urlStr
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              array = [YTsearchKeyWords mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:valueKey]];
              
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    NSLog(@"rr %@",array);
    return  array;
}




@end
