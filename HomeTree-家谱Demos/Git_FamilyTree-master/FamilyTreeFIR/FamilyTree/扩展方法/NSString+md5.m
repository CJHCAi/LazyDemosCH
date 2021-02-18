//
//  NSString+md5.m
//  测试接口
//
//  Created by 姚珉 on 16/5/23.
//  Copyright © 2016年 yaomin. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (md5)
+(NSString *)md5Str:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char md5c[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), md5c);
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [md5Str appendFormat:@"%02x",md5c[i]];
    }
    return  md5Str;
    
    
}

+(NSString *)stringWithDic:(NSDictionary *)dic type:(md5CodingType)codingType{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (codingType == md5CodingTypeOther) {
        NSString *jsonStrn = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *jsonStrnSpace = [jsonStrn stringByReplacingOccurrencesOfString:@" " withString:@""];
        return jsonStrnSpace;
    }
    
    if (codingType == md5CodingTypeUploadArr) {
        NSString *jsonStr1 = [jsonStr stringByReplacingOccurrencesOfString:@"{\n" withString:@"{"];
        NSString *jsonStr2 = [jsonStr1 stringByReplacingOccurrencesOfString:@"\n}" withString:@"}"];
        NSString *jsonStr3 = [jsonStr2 stringByReplacingOccurrencesOfString:@" : " withString:@":"];
        NSString *jsonStr4 = [jsonStr3 stringByReplacingOccurrencesOfString:@",\n" withString:@","];
        NSString *jsonStr5 = [jsonStr4 stringByReplacingOccurrencesOfString:@"  " withString:@""];
        NSString *jsonStr6 = [jsonStr5 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *jsonStr7 = [jsonStr6 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSString *jsonStr8 = [jsonStr7 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        return jsonStr8;
    }
   
    NSString *jsonStr1 = [jsonStr stringByReplacingOccurrencesOfString:@"{\n" withString:@"{"];
    NSString *jsonStr2 = [jsonStr1 stringByReplacingOccurrencesOfString:@"\n}" withString:@"}"];
    NSString *jsonStr3 = [jsonStr2 stringByReplacingOccurrencesOfString:@" : " withString:@":"];
    NSString *jsonStr4 = [jsonStr3 stringByReplacingOccurrencesOfString:@",\n" withString:@","];
    NSString *jsonStr5 = [jsonStr4 stringByReplacingOccurrencesOfString:@"  " withString:@""];
    NSString *jsonStr6 = [jsonStr5 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return jsonStr6;
}


+(NSString *)getCurrentTimeAddNumber{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *currentDate = [formatter stringFromDate:date];
    
    NSInteger randomFour = 1000+random()%(9000);
    
    NSString *currentKey = [NSString stringWithFormat:@"%@%ld",currentDate,(long)randomFour];
        
    return currentKey;
  
}

+(NSString *)verticalStringWith:(NSString *)string{
    if (!string) {
        return @"";
    }
    NSMutableString *mustt = [NSMutableString stringWithString:string];
    
    NSInteger lengt = mustt.length;
    
    for (int idx = 0; idx<lengt-1; idx++) {
        
        [mustt insertString:@"\n" atIndex:1+idx*2];
    }
    
    NSString *resultStr = mustt;
  
    return resultStr;
}

+(NSDictionary *)jsonDicWithDic:(NSDictionary *)dic{
    NSString *jsonStr = [NSString stringWithFormat:@"%@",dic];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *reDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return reDic;
    
}
+(NSArray *)jsonArrWithArr:(NSArray *)arr{
    NSString *jsonStr = [NSString stringWithFormat:@"%@",arr];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * reArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return reArr;
}
@end
