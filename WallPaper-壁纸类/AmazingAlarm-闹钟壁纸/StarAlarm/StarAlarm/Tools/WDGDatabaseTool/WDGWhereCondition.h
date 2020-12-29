//
//  WDGWhereCondition.h
//  WDGSqliteTool
//
//  Created by Wdgfnhui on 16/2/26.
//  Copyright © 2016年 Wdgfnhui. All rights reserved.
//
//  条件类文件

#import <Foundation/Foundation.h>

@interface WDGWhereCondition : NSObject {
    //获取当前的复合条件，数组型，每个元素是一个WDGWhereCondition
    NSMutableArray *_otherConditions;

    //获取当前的对应复合条件的逻辑关系，数组型，每个元素是一个字符串
    NSMutableArray *_relations;

    NSString *_columnName;
    NSString *_Operator;
    id _value;
}

- (NSString *)columnName;

- (NSString *)Operator;

- (id)value;
/****************下面三个基本属性****************/

//@property(nonatomic, strong) NSString *key;
//字段名
//@property(nonatomic, strong) NSString *condition;
//条件内容
//@property(nonatomic, assign) id value;//值

/****************上面三个基本属性****************/




#pragma  ----生成条件便利构造器----

/**
 *  生成一个条件的便利构造器
 *
 *  @param columnName 对应表的字段名 (NSString* 类型)
 *  @param ope        对应查询条件，如 "=", ">", ">=", "<=", "like", "in" 等 (NSString* 类型)
 *  @param value      对应字段要查询的值，任意类型
 *
 *  @return 返回一个where条件
 */

+ (instancetype)conditionWithColumnName:(NSString *)columnName Operator:(NSString *)ope Value:(id)value;
//+ (instancetype)conditionWithKey:(NSString *)key Condition:(NSString *)condition Value:(id)value;//旧版本写法，建议使用上方版本



#pragma  ----添加复合条件----

/**
 *  添加复合条件，由对象调用
 *
 *  @param relation   复合条件的逻辑关系，如 "and", "or" 等 (NSString* 类型)
 *  @param columnName 用法同便利构造器
 *  @param ope        用法同便利构造器
 *  @param value      用法同便利构造器
 */
- (void)addWhereConditionWithRelation:(NSString *)relation ColumnName:(NSString *)columnName Operator:(NSString *)ope Value:(id)value;

//- (void)addWhereConditionWithRelation:(NSString *)relation Key:(NSString *)key Condition:(NSString *)condition Value:(id)value;//旧版本写法，建议使用上方版本
#pragma  ----删除复合条件中的一个----

- (void)removeConditionAtIndex:(NSUInteger)index;

- (void)deleteWhereConditionWithRelation:(NSString *)relation Conditon:(WDGWhereCondition *)condition;


- (NSMutableArray *)otherConditions;

- (NSMutableArray *)relations;
////获取当前的复合条件，数组型，每个元素是一个WDGWhereCondition
//@property(nonatomic, strong) NSMutableArray *otherConditions;
//
////获取当前的对应复合条件的逻辑关系，数组型，每个元素是一个字符串
//@property(nonatomic, strong) NSMutableArray *relations;

@end
