//
//  ARRegularExpression.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/27.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARRegularExpression : NSObject

+(NSString *)getRealMessageWithStr:(NSString *)str pattern:(NSString *)pattern;
+(NSString *)handleImagesUrlstr:(NSString *)imagesUrlStr pattern:(NSString *)pattern;
+(NSMutableArray *)getListMaterialWithMsgStr:(NSString *)str pattern:(NSString *)pattern;
+(NSString *)getChapter:(NSString *)defaultStr pattern:(NSString *)pattern;

@end
