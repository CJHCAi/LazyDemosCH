//
//  MOVturnMP4.h
//  X SCHOOL
//
//  Created by lijie on 16/7/4.
//  Copyright © 2016年 chenggongqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVturnMP4 : NSObject

+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock;
@end
