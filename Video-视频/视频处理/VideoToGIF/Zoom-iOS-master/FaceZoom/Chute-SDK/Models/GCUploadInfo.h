//
//  GCUploadInfo.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCUploadInfo : NSObject

@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *uploadUrl;

@end
