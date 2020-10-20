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


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com