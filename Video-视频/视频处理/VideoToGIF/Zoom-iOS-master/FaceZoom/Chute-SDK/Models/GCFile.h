//
//  GCFile.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCFile : NSObject

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSNumber *fileSize;
@property (strong, nonatomic) NSString *MD5Hash;

+ (instancetype)fileAtPath:(NSString *)filePath;
+ (instancetype)fileWithUIImage:(UIImage *)image;

- (instancetype)initWithFileAtPath:(NSString *)filePath;
- (NSDictionary *)serialize;


@end
