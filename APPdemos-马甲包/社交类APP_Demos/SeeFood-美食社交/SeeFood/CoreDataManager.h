//
//  CoreDataManager.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "VideoModel.h"


@interface CoreDataManager : NSObject
//  单例
+ (CoreDataManager *)shareInstance;
//  初始化数据库
- (void)initCoreData;
//  注册新用户
- (void) addNewUserWithUserModel:(UserModel *)model;
//  查询用户名
- (BOOL) checkUsername:(NSString *)username;
//  查询密码
- (BOOL)checkPassword:(NSString *)password withUsername:(NSString *)username;
//  获取user model
- (UserModel *)getUserModelWithUsername:(NSString *)username;

//  插入数据
- (void)insertDataWithModel:(VideoModel *)inModel username:(NSString *)username;
//  读取数据
- (BOOL)selectDataWithID:(NSInteger)id username:(NSString *)username;
//  删除记录
- (void)deleteDataWithID:(NSInteger)id username:(NSString *)username;
//  查找所有数据
- (NSMutableArray *)getAllDataWithUsername:(NSString *)username;


//  添加新搜索
- (void)addNewTitleWithSearch:(NSString *)title;
//  查询所有历史搜索
- (NSArray *)selectAllTitleModel;
//  清空所有历史搜索
- (void)deleteAllSearchModel;
//  删除某一个搜索
- (void)deleteOneTitle:(NSString *)title;

//  写入数据
- (void)insertDataWithUsername:(NSString *)username;
//  查找数据
- (NSString *)selectLogedUsername;
//  删除数据
- (void)deleteLogedUsername;
@end
