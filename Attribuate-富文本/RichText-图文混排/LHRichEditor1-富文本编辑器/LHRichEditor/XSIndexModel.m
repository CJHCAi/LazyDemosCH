//
//  XSIndexModel.m
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/24.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "XSIndexModel.h"

@implementation XSIndexModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    
    if (self) {
        if (dic[@"type"]) {
            _type = [[NSString stringWithFormat:@"%@",dic[@"type"]] integerValue] ;
        }
        if (dic[@"day"]) {
           _day = [NSString stringWithFormat:@"%@",dic[@"day"]] ;
        }
        if (dic[@"week"]) {
            _week = [NSString stringWithFormat:@"%@",dic[@"week"]] ;
        }
        if (dic[@"time"]) {
            _time = [NSString stringWithFormat:@"%@",dic[@"time"]] ;
        }
        if (dic[@"title"]) {
            _title = [NSString stringWithFormat:@"%@",dic[@"title"]] ;
        }
        if (dic[@"image"]) {
            _img = [NSString stringWithFormat:@"%@",dic[@"image"]] ;
        }
        if (dic[@"year"]) {
            _year = [NSString stringWithFormat:@"%@",dic[@"year"]] ;
        }
        if (dic[@"moth"]) {
            _moth = [NSString stringWithFormat:@"%@",dic[@"moth"]] ;
        }
        if (dic[@"index"]) {
            _index = [[NSString stringWithFormat:@"%@",dic[@"index"]] integerValue] ;
        }
        if (dic[@"weatherType"]) {
            _weatherType = [NSString stringWithFormat:@"%@",dic[@"weatherType"]]  ;
        }
        if (dic[@"words"]) {
            _words = [[NSString stringWithFormat:@"%@",dic[@"words"]] integerValue]  ;
        }
        if (dic[@"today"]) {
            _today = [NSString stringWithFormat:@"%@",dic[@"today"]]  ;
        }
        if (dic[@"content"]) {
            _content = [NSString stringWithFormat:@"%@",dic[@"content"]]  ;
        }
    }
    
    
    return self;
    
}
@end
