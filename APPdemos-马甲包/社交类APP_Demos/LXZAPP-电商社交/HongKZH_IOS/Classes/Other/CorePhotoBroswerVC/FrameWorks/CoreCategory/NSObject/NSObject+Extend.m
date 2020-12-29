//
//  NSObject+Address.m
//  网易彩票2014MJ版
//
//  Created by muxi on 14-9-23.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import "NSObject+Extend.h"
#import <objc/message.h>


@implementation NSObject (Extend)


#pragma mark  返回任意对象的字符串式的内存地址
-(NSString *)address{
    return [NSString stringWithFormat:@"%p",self];
}




#pragma mark  调用方法
-(void)callSelectorWithSelString:(NSString *)selString paramObj:(id)paramObj{
    
    //转换为sel
    SEL sel=NSSelectorFromString(selString);
    
    if(![self respondsToSelector:sel]) return;
    
    //调用
//    objc_msgSend(self, sel);
    
}



//+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL {
//    UIImage *shotImage;
//    //视频路径URL
//    NSURL *fileURL = videoURL;
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    shotImage = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//    return shotImage;
//}

@end
