//
//  ZSDBBaseModel.h
//  HandsUp
//
//  Created by wanghui on 2018/4/19.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSDBBaseModel : NSObject
@property(nonatomic, assign) int ID;

/**
 对应数据库的表名
 */
@property (nonatomic, copy)NSString *tableName;

/**
 where 语句 的字段 各个子模型有默认值
 */
@property (nonatomic, strong)NSMutableArray *whereIdDict;

/**
 update时 set 字段 = vause 调用update的时候给其赋值，如果为空则取（全部字段-忽略字段）如果设置则已这个为标准
 */
@property (nonatomic, strong)NSDictionary *updateDict;

@property (nonatomic, strong)NSMutableArray *selectArray;;
/**
 update时候忽略的字段 各个子模型有默认值
 */
@property (nonatomic, strong)NSMutableArray *elideField;

-(BOOL)isExsistWithFieldArray:(NSArray*)array andDB:(FMDatabase*)db;


/**
 判断是否是需要忽略的字段

 @param Field 字段名
 @return 结果
 */
-(BOOL)isElideField:(NSString*)Field;


+(instancetype)getModelWithRs:(FMResultSet*)rs andCls:(Class)cls;


@property (nonatomic, copy)NSString *param10;
@property (nonatomic, copy)NSString *param9;
@property (nonatomic, copy)NSString *param8;
@property (nonatomic, copy)NSString *param7;
@property (nonatomic, copy)NSString *param6;
@property (nonatomic, copy)NSString *param5;
@property (nonatomic, copy)NSString *param4;
@property (nonatomic, copy)NSString *param3;
@property (nonatomic, copy)NSString *param2;
@property (nonatomic, copy)NSString *param1;
-(BOOL)isHasTable:(FMDatabase*)db;
@end
