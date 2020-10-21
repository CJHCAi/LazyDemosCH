//
//  RecordVideoViewController+AllowEditing.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordVideoViewController.h"
@import AVFoundation;

@interface RecordVideoViewController(AllowEditing)

+(NSString*)createPath;
+(AVAssetExportSession*)configureExportSession:(AVAssetExportSession*)session
                                     outputURL:(NSString*)outputURL
                             startMilliseconds:(int)start
                               endMilliseconds:(int)end;

@end
