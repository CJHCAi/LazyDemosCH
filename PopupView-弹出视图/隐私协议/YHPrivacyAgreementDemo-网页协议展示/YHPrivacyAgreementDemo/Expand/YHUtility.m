//
//  YHUtility.m
//  YHPrivacyAgreementDemo
//
//  Created by survivors on 2019/1/30.
//  Copyright © 2019年 survivorsfyh. All rights reserved.
//

#import "YHUtility.h"

#define kDocumentPath       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

/**
 本地生成 plist 文件(字典 Dic)
 
 @param dataSource  写入数据源
 @param fileName    文件名次
 @param filePath    文件路径
 */
void CreateLocalPlistFile(NSMutableDictionary *dataSource, NSString *fileName, NSString *filePath) {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if ([manager createDirectoryAtPath:[kDocumentPath stringByAppendingPathComponent:filePath] withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"本地生成 plist 文件 --- 创建 --- 成功");
        //将字典对象归档存入文件
        if ([dataSource writeToFile:[[kDocumentPath stringByAppendingPathComponent:filePath] stringByAppendingPathComponent:fileName] atomically:YES]) {
            NSLog(@"本地生成 plist 文件 --- 写入 --- 成功");
            //将文件内容读成字典对象
            NSDictionary *plistInfo = [NSDictionary dictionaryWithContentsOfFile:[kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", filePath, fileName]]];
            NSLog(@"The Plist File\nInfo --- %@\nPath --- %@", plistInfo, [kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", filePath, fileName]]);
        }
        else {
            NSLog(@"本地生成 plist 文件 --- 写入 --- 失败\nError:%@", error.localizedDescription);
        }
    }
    else {
        NSLog(@"本地生成 plist 文件 --- 创建 --- 失败\nError:%@\nPath:%@", error.localizedDescription, filePath);
    }
}

/**
 插入对象至本地 plist 文件
 
 @param dataSource  数据源
 @param fileName    文件名称
 @param filePath    文件路径
 */
void InsertObjectToLocalPlistFile(NSMutableDictionary *dataSource, NSString *fileName, NSString *filePath) {
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //
    //    });
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", filePath, fileName]];
    if ([fileManager fileExistsAtPath:docPath]) {// 文件存在
        NSLog(@"本地 plist 文件 --- 存在");
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithContentsOfFile:docPath];
        [result addEntriesFromDictionary:dataSource];
        [result writeToFile:[[kDocumentPath stringByAppendingPathComponent:filePath] stringByAppendingPathComponent:fileName] atomically:YES];
    }
    else {// 文件不存在
        NSLog(@"本地 plist 文件 --- 不存在");
        CreateLocalPlistFile(dataSource, fileName, filePath);
    }
}

