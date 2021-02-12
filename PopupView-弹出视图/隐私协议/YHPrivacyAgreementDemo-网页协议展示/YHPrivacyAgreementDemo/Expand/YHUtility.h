//
//  YHUtility.h
//  YHPrivacyAgreementDemo
//
//  Created by survivors on 2019/1/30.
//  Copyright © 2019年 survivorsfyh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 插入对象至本地 plist 文件
 
 @param dataSource  数据源
 @param fileName    文件名称
 @param filePath    文件路径
 */
extern void InsertObjectToLocalPlistFile(NSMutableDictionary *dataSource, NSString *fileName, NSString *filePath);
