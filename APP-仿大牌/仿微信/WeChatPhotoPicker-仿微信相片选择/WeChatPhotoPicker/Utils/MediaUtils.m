//
//  MediaUtils.m
//  模仿微信相册
//
//  Created by Mac on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MediaUtils.h"

@implementation MediaUtils

+(NSString *)getTempPath{
    /*
     获取这些目录路径的方法：
     1，获取家目录路径的函数：
     NSString *homeDir = NSHomeDirectory();
     2，获取Documents目录路径的方法：
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *docDir = [paths objectAtIndex:0];
     3，获取Caches目录路径的方法：
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
     NSString *cachesDir = [paths objectAtIndex:0];
     4，获取tmp目录路径的方法：
     NSString *tmpDir = NSTemporaryDirectory();
     5，获取应用程序程序包中资源文件路径的方法：
     例如获取程序包中一个图片资源（apple.png）路径的方法：
     NSString *imagePath = [[NSBundle mainBundle] pathForResource:@”apple” ofType:@”png”];
     UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
     代码中的mainBundle类方法用于返回一个代表应用程序包的对象。
     */
    NSString* tempPath = NSTemporaryDirectory();
    
    //    NSString* userAccountPath = [docPath stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] stringForKey:@"nameAccount"]];
    
    NSString* tempMediaPath = [tempPath stringByAppendingPathComponent:@"tempMedia"];
    
    BOOL isDir = NO;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    BOOL existed = [fm fileExistsAtPath:tempMediaPath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        
        [fm createDirectoryAtPath:tempMediaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return tempMediaPath;
}

+(void)deleteTempPath{
    NSString* path = [MediaUtils getTempPath];
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:path isDirectory:&isDir];
    
    NSError* error = nil;
    if (existed) {
        [fm removeItemAtPath:path error:&error];
        NSLog(@"deleteError:%@", error);
    }
}

+(void)deleteFileByPath:(NSString *)path{
    if (!path) {
        return;
    }
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:path isDirectory:&isDir];
    
    NSError* error = nil;
    if (existed) {
        [fm removeItemAtPath:path error:&error];
        NSLog(@"deleteError:%@", error);
    }
}

+(long long)getFileSize:(NSString *)filePath{
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    long long size = [fileHandle seekToEndOfFile];
    NSLog(@"文件大小:::: %lld", size);
    return size;
}

+(void)writePHVedio:(PHAsset*)asset toPath:(NSString*)path block:(void (^)(NSURL* url))finishBlock{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset* phAsset = (PHAsset*)asset;
        NSArray* assetResources = [PHAssetResource assetResourcesForAsset:phAsset];
        PHAssetResource* assetResource = nil;
        for (PHAssetResource* assetRes in assetResources)
            if (assetRes.type == PHAssetMediaTypeVideo) assetResource = assetRes;
        
        if (assetResource) {
            NSLog(@"===============源文件名称%@", assetResource.originalFilename);
            
            if (!path) {
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
                [formater setDateFormat:@"yyyyMMddHHmmss"];
                NSString* fileName = [NSString stringWithFormat:@"temp%@.m4v", [formater stringFromDate:[NSDate date]]];
                path = [[MediaUtils getTempPath] stringByAppendingPathComponent:fileName];
                NSLog(@"temp路径：：：：：：：：：%@", path);
            }
            NSURL* url = [NSURL fileURLWithPath:path];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:assetResource toFile:url options:nil completionHandler:^(NSError * _Nullable error) {
                if (finishBlock) {
                    finishBlock(url);
                }else{if (finishBlock) finishBlock(nil);}
            }];
        }else{  if (finishBlock) finishBlock(nil);}
        
    }else { if (finishBlock) finishBlock(nil);}
}

/**
 *  @author 嘴爷, 2016-05-26 15:05:07
 *  @brief 压缩文件
 */
+(void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                             outputURL:(NSURL*)outputURL
                       completeHandler:(void (^)(AVAssetExportSession* exportSession, NSURL* compressedOutputURL)) handler
{
    if (!inputURL) {
        return;
    }
    
    if (!outputURL) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        NSString* fileName = [NSString stringWithFormat:@"compossTemp%@.m4v", [formater stringFromDate:[NSDate date]]];
        NSString* outPath = [[MediaUtils getTempPath] stringByAppendingPathComponent:fileName];
        outputURL = [NSURL fileURLWithPath:outPath];
        
        NSLog(@"outPath    %@", outPath);
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputURL.path]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputURL.path error:nil];
    }
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
    exportSession.fileLengthLimit = 1024 * 1024 * 5;//大小不能超过5M
    long long vedioSize = exportSession.estimatedOutputFileLength;
    NSLog(@"压缩后大小为:%lld", vedioSize);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusUnknown:
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted: {
                
                break;
            }
            case AVAssetExportSessionStatusFailed:
                break;
                
            case AVAssetExportSessionStatusCancelled:
                break;
                
            default:
                break;
        }
        
        if (handler) {
            handler(exportSession, outputURL);
        }
        NSLog(@"压缩状态  %ld", (long)exportSession.status);
        
    }];
}

+ (NSURL *)convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}


@end
