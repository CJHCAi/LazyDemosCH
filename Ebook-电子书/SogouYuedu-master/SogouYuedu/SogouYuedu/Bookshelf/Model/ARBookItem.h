//
//  ARBookItem.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARBookItem : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *imageKey;

@property(nonatomic,copy)NSString *bookid;

@property(nonatomic,copy)NSString *md;

@property(nonatomic,copy)NSString *count;

@property(nonatomic,copy)NSString *author;

@property(nonatomic,copy)NSString *loc;

@property(nonatomic,copy)NSString *eid;

@property(nonatomic,copy)NSString *bkey;

@property(nonatomic,copy)NSString *token;



+ (instancetype) BookItemWithName:(NSString *)name
                         imageKey:(NSString *)imageKey
                           bookid:(NSString *)bookid
                               md:(NSString *)md
                            count:(NSString *)count  //请求个数，1就是只下载一个txt文件，第一章，2就是下载前两章
                           author:(NSString *)author
                              loc:(NSString *)loc
                              eid:(NSString *)eid
                             bkey:(NSString *)bkey
                            token:(NSString *)token;

+(NSMutableArray *)readDatabase;

@end
