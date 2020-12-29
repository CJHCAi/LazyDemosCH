//
//  ZSDBManageBaseModel.h
//  HandsUp
//
//  Created by wanghui on 2018/4/19.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSDBBaseModel.h"
typedef enum {
    implementType_insert = 0,
    implementType_delete = 1,
    implementType_update = 2,
    implementType_select = 3
}implementType;
@interface ZSDBManageBaseModel : NSObject
SISingletonH(ZSDBManageBaseModel)
/**
 获取sql语句

 @param dataModel 数据结构
 @param type 选择增删改查
 @return sql
 */
-(NSString*)getSqlString:(ZSDBBaseModel*)dataModel withImplementType:(implementType)type;
/**
 单个插入数据库

 @param dataModel 数据库对应的表模型
 @return 是否插入成功
 */
-(BOOL)insertWithModel:(ZSDBBaseModel*)dataModel;

/**
 批量插入数据库

 @param dataArray 数据库模型数组
 @param sucBlock 是否插入成功
 */
-(void)insertWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;

/**
 批量删除

 @param dataArray 数据库模型数组
 @param sucBlock 是否删除成功
 */
-(void)deleteWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;

/**
 批量删除之是否逻辑删除

 @param dataArray 数据库模型数组
 @param isLogicallyDelete 是否逻辑删除
 @param sucBlock 是否删除成功
 */
-(void)deleteWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andIsLogicallyelete:(BOOL)isLogicallyDelete andSuc:(void(^)(BOOL isSuc))sucBlock;
/**
 批量删除不需要编写where字典的
 
 @param dataArray 数据库模型数组
 @param sucBlock 是否删除成功
 */
-(void)deleteNotWhereWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;

/**
 批量修改数据库

 @param dataArray 数据模型数组
 @param sucBlock 是否修改成功
 */
-(void)updateDataWithArray:(NSArray<ZSDBBaseModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;

/**
 查询方法

 @param sqlStr 查询sql语句
 @return 结果
 */
-(FMResultSet*)queryWithSql:(NSString *)sqlStr;

/**
 根据模型查询

 @param dataModel 模型属性赋值 whereDict，里面是需要添加的查询条件，如果没有为nil
 @return 结果
 */
-(ZSDBBaseModel*)queryWithModel:(ZSDBBaseModel*)dataModel;

/**
 根据返回结果的类 和sql语句查询

 @param cls 返回数组里包含什么类
 @param sql sql sql语句
 @return return 结果数组
 */
-(NSArray*)queryWihtClass:(Class)cls andSql:(NSString*)sql;
-(NSArray*)analysisWihtClass:(Class)cls andRs:(FMResultSet*)rs;
-(void)updateNotThingDataWithArray:(ZSDBBaseModel*)dataModel andSuc:(void(^)(BOOL isSuc))sucBlock;
@end
