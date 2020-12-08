//
//  YTRegularExpression.h
//  每日烹
//
//  Created by Mac on 16/5/1.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTRegularExpression : NSObject
+(NSString *)getRealMessageWithStr:(NSString *)str pattern:(NSString *)pattern;
+(NSString *)handleImagesUrlstr:(NSString *)imagesUrlStr pattern:(NSString *)pattern;
+(NSMutableArray *)getListMaterialWithMsgStr:(NSString *)str pattern:(NSString *)pattern;
+(NSString *)getChapter:(NSString *)defaultStr pattern:(NSString *)pattern;
@end
