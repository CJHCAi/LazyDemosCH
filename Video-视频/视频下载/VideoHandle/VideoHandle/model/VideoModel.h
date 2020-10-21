//
//  VideoModel.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/17.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

//视频链接
@property (nonatomic,copy) NSString *url;

//视频封面
@property (nonatomic,copy) NSData *poster;

//视频标题
@property (nonatomic,copy) NSString *title;

//视频时长
@property (nonatomic,copy) NSString *duration;

//视频大小
@property (nonatomic,copy) NSString *memorySize;

//沙盒路径
@property (nonatomic,copy) NSString *path;

@end
