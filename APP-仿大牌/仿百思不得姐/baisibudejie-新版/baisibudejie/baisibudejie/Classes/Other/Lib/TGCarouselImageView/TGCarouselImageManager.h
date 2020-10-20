//
//  TGCarouselImageManager.h
//  baisibudejie
//
//  Created by targetcloud on 2017/6/1.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  Blog http://blog.csdn.net/callzjy
//  Mail targetcloud@163.com
//  Github https://github.com/targetcloud

#import <Foundation/Foundation.h>

@interface TGCarouselImageManager : NSObject
@property (nonatomic, assign) NSUInteger repeatCountWhenDownloadFailed;
@property (nonatomic, copy) void(^downloadImageSuccess)(UIImage *image, NSInteger imageIndex);
@property (nonatomic, copy) void(^downloadImageFailure)(NSError *error, NSString *imageURLString);
- (void)downloadImageURLString:(NSString *)imageURLString imageIndex:(NSInteger)imageIndex;
+ (void)clearCachedImages;
@end
