//
//  GCFileManager.h
//  Shortener
//
//  Created by Aleksandar Trpeski on 1/5/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCFileManager : NSObject

+ (void)removeTempFiles;
+ (NSString *)createTempFileWithData:(NSData *)data extension:(NSString *)extension;
+ (NSString *)applicationDocumentsDirectory;

@end
