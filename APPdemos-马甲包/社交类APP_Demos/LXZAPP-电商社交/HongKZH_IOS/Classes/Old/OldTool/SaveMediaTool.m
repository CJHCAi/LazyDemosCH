//
//  SaveMediaTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "SaveMediaTool.h"

@implementation SaveMediaTool

+ (BOOL) saveImgSrcWithImageName:(NSString *)imgName image:(UIImage *)image {
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *filePath = [LKDBUtils getPathForDocuments:imgName inDir:@"draft"];
    return [imgData writeToFile:filePath atomically:YES];
}

+ (UIImage *)getImgWithImageName:(NSString *)imgName {
    NSString *filePath = [LKDBUtils getPathForDocuments:imgName inDir:@"draft"];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
