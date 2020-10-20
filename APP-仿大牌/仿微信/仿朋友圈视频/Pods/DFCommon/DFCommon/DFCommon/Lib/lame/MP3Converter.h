//
//  MP3Converter.h
//  iphone
//
//  Created by Allen Zhong on 14/9/17.
//  Copyright (c) 2014年 Datafans Inc. All rights reserved.
//


#import <lame/lame.h>


@interface MP3Converter : NSObject

+(void) convert: (NSString *) srcPath targetPath:(NSString *) targetPath;

@end


