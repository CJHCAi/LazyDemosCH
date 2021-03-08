//
//  NSString+Extend.h
//  CoreCategory
//
//  Created by 李壮 on 16/2/28.
//  Copyright (c) 2016年 李壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

/*
 *  得到字符串的高度
 */
- (CGFloat)getHeightWithFontSize:(CGFloat)fontSize andConstrainedWidth:(CGFloat)width;
/*
 * 判断是否包含Str
 */
- (BOOL)isRangeOfString:(NSString *)str;
/*
 * 得到本地文件路径
 */
+ (NSString *)fileDocumentPath:(NSString *)name ofType:(NSString *)type;

/*
 * 得到本地文件路径
 */
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName ofType:(NSString *)type;



/** 删除所有的空格 */
@property (nonatomic,copy,readonly) NSString *deleteSpace;



/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate *date;



/**
 *  时间戳转格式化的时间字符串
 */
-(NSString *)timestampToTimeStringWithFormatString:(NSString *)formatString;

///正则筛选手机号
+ (BOOL)checkTelNumber:(NSString*) mobileNumbel;
///计算字符串长度 三个参数，第一个参数：要计算的字符串，第二个参数，lalbel的字体大小，第三个参数，label允许的最大尺寸。
+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
///筛选身份证号
+(BOOL)Chk18PaperId:(NSString *)idCard;
///筛选汉字
+(BOOL)ChkNSString:(NSString *)string;
///json格式字符串转化字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
///字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
