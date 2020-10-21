//
//  JPEG.h
//  LearnTestDemo
//
//  Created by BY_R on 2017/3/2.
//  Copyright © 2017年 BY_R. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString    *const  kFigAppleMakerNote_AssetIdentifier = @"17";

@interface JPEG : NSObject
@property (nonatomic, copy) NSString    *path;
- (id)initWithPath:(NSString *)path;
- (NSString *)read;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;
@end
