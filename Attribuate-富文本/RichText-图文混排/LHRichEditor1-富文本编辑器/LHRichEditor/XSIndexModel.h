//
//  XSIndexModel.h
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/24.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSIndexModel : NSObject
@property (nonatomic,assign) NSInteger type;//是否有日记
@property (nonatomic,copy)NSString *day;
@property (nonatomic,copy)NSString *week;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *year;
@property (nonatomic,copy)NSString *moth;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString * weatherType;
@property (nonatomic,assign) NSInteger words;
@property (nonatomic,copy)NSString *today;
@property (nonatomic,copy)NSString *content;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
