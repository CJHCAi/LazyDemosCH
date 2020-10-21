//
//  GCFileManager.m
//  Shortener
//
//  Created by Aleksandar Trpeski on 1/5/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCFileManager.h"
#import "GCLog.h"

@implementation GCFileManager

+ (NSString *) GCTempDirectory {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(nsdo, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/GCTempDirectory"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            return dataPath;
        else
        {
            GCLogError(@"Attempting to write create GCTempDirectory directory");
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
            return nil;
        }
    }
    else return dataPath;
}

+ (NSArray *)listFilesAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//        
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    __block NSMutableArray *filePaths = [[NSMutableArray alloc] initWithCapacity:[directoryContent count]];
    
    [directoryContent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [filePaths addObject:[path stringByAppendingPathComponent:obj]];
    }];
 
    return [NSArray arrayWithArray:filePaths];
}

+ (NSString *)createTempFileWithData:(NSData *)data extension:(NSString *)extension {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [self generateUUID], extension];
    NSString *filePath = [[self GCTempDirectory] stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

+ (void)removeTempFiles {
    __block NSFileManager *fileManager = [NSFileManager defaultManager];
    __block NSError *error;
    NSString *tempDirectory = [self GCTempDirectory];
    NSArray *tempFiles = [self listFilesAtPath:tempDirectory];
    
    [tempFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [fileManager removeItemAtPath:obj error:&error];
        
        if (error) {
            GCLogWarning(@"ERROR: %@ \n\tPath: %@", [error localizedDescription], obj);
        }
        
    }];
    
}

+ (NSString *)generateUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString substringToIndex:8]; //specify length here. even you can use full
}




#pragma mark - Application's Documents directory

+ (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSURL *)applicationDocumentsDirectoryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
