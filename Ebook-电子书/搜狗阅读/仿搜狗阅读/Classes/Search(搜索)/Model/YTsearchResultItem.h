//
//  YTsearchResultItem.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTsearchResultItem : NSObject

@property(nonatomic,copy)NSString *bkey;

@property(nonatomic,copy)NSString *book;

@property(nonatomic,copy)NSString *author;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *desc;

@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *chapter;

@property(nonatomic,copy)NSString *chapterurl;

@property(nonatomic,copy)NSString *chaptermd5;

@property(nonatomic,copy)NSString *chaptercid;

@property(nonatomic,copy)NSString *site;

@property(nonatomic,copy)NSString *date;

@property(nonatomic,copy)NSString *chapterNum;

@property(nonatomic,copy)NSString *id;

@property(nonatomic,copy)NSString *md;

@property(nonatomic,copy)NSString *loc;

@property(nonatomic,copy)NSString *sourceLoc;

@property(nonatomic,copy)NSString *sourceNum;

@property(nonatomic,copy)NSString *nameMD5;

@property(nonatomic,copy)NSString *authorMD5;

@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *picurl;
@end
