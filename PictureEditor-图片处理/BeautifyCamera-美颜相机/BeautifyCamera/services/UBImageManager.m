//
//  UBImageManager.m
//  BeautifyCamera
//
//  Created by sky on 2017/1/18.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "UBImageManager.h"


@interface UBImageManager ()
@property (nonatomic, readonly) NSFileManager * fileManager;
@property (nonatomic, readonly) NSString * storePath;
@end

@implementation UBImageManager

+(instancetype) manager{
    static UBImageManager * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[UBImageManager alloc] init];
    });
    return _manager;
}

-(NSString *)storePath{
    static NSString * _path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        _path = [paths[0] stringByAppendingPathComponent:@"Photos"];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:_path]){
            [[NSFileManager defaultManager]  createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return _path;
}

-(NSString *) storeImage:(UIImage *)image{
    NSString * key = [self generateCacheKey];
    NSString * imagePath = [self.storePath stringByAppendingPathComponent:key];
    
//    NSData * data = UIImagePNGRepresentation(image);
    NSData * data = UIImageJPEGRepresentation(image, 1);
    [self.fileManager createFileAtPath:imagePath contents:data attributes:nil];
    return key;
}


-(NSArray *) listImageFilePath{

    NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.storePath];
    
    return fileEnumerator.allObjects;
}

-(UIImage *) loadImage:(NSString *) name{
    NSString * filePath = nil;
    if ([name hasPrefix:self.storePath]) {
        filePath = name;
    }
    else{
        filePath = [self.storePath stringByAppendingPathComponent:name];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    
    return nil;
}

-(BOOL) deleteImage: (NSString *) filename{
    NSString * filePath = [self.storePath stringByAppendingPathComponent:filename];
    BOOL flag = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError * error = nil;
        flag = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if(error){
            NSLog(@"remove file: %@, failed: %@", filename, error);
        }
    }
    
    return flag;
}

#pragma mark private methods

-(NSFileManager *) fileManager{
    return [NSFileManager defaultManager];
}

-(NSString *)generateCacheKey{
    static NSDateFormatter * formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMdd_HHmmss";
    });
    
    NSString * key = [formatter stringFromDate:[NSDate date]];
    NSString * keyCopy = key;
    NSInteger * index = 0;
    key = [key stringByAppendingPathExtension:@"jpg"];
    
    while ([self.fileManager fileExistsAtPath:[self.storePath stringByAppendingPathComponent:key]]) {
        index++;
        key = [NSString stringWithFormat:@"%@(%ld).jpg", keyCopy, (long)index];
    }
    
    return key;
}

@end
