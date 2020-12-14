//
//  ARChaptersItem.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARChaptersItem : NSObject

@property(nonatomic,copy)NSString *free;

@property(nonatomic,copy)NSString *gl;

@property(nonatomic,copy)NSString *buy;

@property(nonatomic,copy)NSString *rmb;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *md5;


//nobkey 有三个属性，分别是name ,cmd ,url
@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *cmd;

+ (instancetype) ChaptersWithFree:(NSString *)free
                               gl:(NSString *)gl
                              buy:(NSString *)buy
                              rmb:(NSString *)rmb
                             name:(NSString *)name
                              md5:(NSString *)md5
                              url:(NSString *)url
                              cmd:(NSString *)cmd;

+ (NSMutableArray *)readDatabaseFromTable:(NSString *)table;
//只读取一章，节约开销
+ (NSMutableArray *)readOneChapterFromTable:(NSString *)table Index:(NSInteger)index;

@end
