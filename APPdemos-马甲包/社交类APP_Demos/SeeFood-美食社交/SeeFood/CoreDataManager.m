//
//  CoreDataManager.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "User+CoreDataProperties.h"
#import "Video+CoreDataProperties.h"
#import "Search+CoreDataProperties.h"
#import "Login+CoreDataProperties.h"


@interface CoreDataManager ()
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CoreDataManager
//  单例
+ (CoreDataManager *)shareInstance {
    static CoreDataManager *manager = nil;
    if (manager == nil) {
        manager = [[CoreDataManager alloc]init];
    }
    return manager;
}

//  初始化数据库
- (void)initCoreData {
    _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    //  CoreData路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Model" ofType:@"momd"];
    //  数据模型关联
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //  存储路径
    NSString *sqlite = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"CoreData.sqlite"];
    NSLog(@"%@",sqlite);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlite] options:nil error:nil];
    self.context.persistentStoreCoordinator = store;
}

//  注册新用户
- (void) addNewUserWithUserModel:(UserModel *)model{
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
    newUser.username = model.username;
    newUser.email = model.email;
    newUser.password = model.password;
    newUser.phone = model.phone;
    newUser.photoURL = model.photoURL;
    //  添加到数据库
    [self.context save:nil];
}

//  查询用户名
- (BOOL) checkUsername:(NSString *)username {
    //  查询
    //  创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    //  查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    request.predicate = predicate;
    //  遍历
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    if (array == nil || array.count == 0) {
        return NO;
    }
    return YES;
}

//  查询密码
- (BOOL)checkPassword:(NSString *)password withUsername:(NSString *)username {
    //  查询
    //  创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    //  查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@ and password = %@", username, password];
    request.predicate = predicate;
    //  遍历
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    if (array == nil || array.count == 0) {
        return NO;
    }
    return YES;
}

- (UserModel *)getUserModelWithUsername:(NSString *)username{
    //  查询
    //  创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    // 查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    UserModel *user = [array firstObject];
    return user;
}

#pragma mark -------收藏
//  插入数据
- (void)insertDataWithModel:(VideoModel *)inModel username:(NSString *)username {
    Video *model = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:self.context];
    model.title = inModel.title;
    model.date = [NSDate dateWithTimeIntervalSinceNow:inModel.date];
    model.collectionCount = [NSNumber numberWithInteger:inModel.collectionCount];
    model.coverForDetail = inModel.coverForDetail;
    model.coverBlurred = inModel.coverBlurred;
    model.playUrl = inModel.playUrl;
    model.id = [NSNumber numberWithInteger:inModel.id];
    model.username = username;
    [self.context save:nil];
}


//  读取数据
- (BOOL)selectDataWithID:(NSInteger)id username:(NSString *)username {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %d and username = %@", id, username];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    if (array.count == 0) {
        return NO;
    }else {
        return YES;
    }
}

//  删除记录
- (void)deleteDataWithID:(NSInteger)id username:(NSString *)username  {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %d and username = %@", id, username];
    request.predicate = predicate;
    Video *model = [self.context executeFetchRequest:request error:nil].lastObject;
    [self.context deleteObject:model];
    [self.context save:nil];
}

//  查找所有数据
- (NSMutableArray *)getAllDataWithUsername:(NSString *)username {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    request.predicate = predicate;
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    NSMutableArray *outArray = [NSMutableArray array];
    for (Video *inModel in array) {
        VideoModel *outModel = [[VideoModel alloc]init];
        outModel.title = inModel.title;
        outModel.date = [inModel.date timeIntervalSince1970];
        outModel.collectionCount = [inModel.collectionCount integerValue];
        outModel.coverForDetail = inModel.coverForDetail;
        outModel.coverBlurred = inModel.coverBlurred;
        outModel.playUrl = inModel.playUrl;
        outModel.id = [inModel.id integerValue];
        [outArray addObject:outModel];
    }
    return outArray;
}

#pragma mark --------登陆

//  写入数据
- (void)insertDataWithUsername:(NSString *)username {
    Login *model = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:self.context];
    model.username = username;
    [self.context save:nil];
}

//  查找数据
- (NSString *)selectLogedUsername{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Login"];
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    Login *model = [array lastObject];
    return model.username;
}

//  删除数据
- (void)deleteLogedUsername {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Login"];
    Login *model = [self.context executeFetchRequest:request error:nil].lastObject;
    [self.context deleteObject:model];
    [self.context save:nil];

}

#pragma mark --------搜索记录

//  添加新搜索
- (void)addNewTitleWithSearch:(NSString *)title
{
    Search *search=[NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:_context];
    search.title=title;
//    NSLog(@"add  %@", search.title);
    [self.context save:nil];
    
    NSArray *array=[[CoreDataManager shareInstance]selectAllTitleModel];
    if(array.count>5)
    {
        NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Search"];
        NSArray *array=[self.context executeFetchRequest:request error:nil];
        [self.context deleteObject:array.firstObject];
    }
    [self.context save:nil];
}
//  查询所有历史搜索
- (NSArray *)selectAllTitleModel
{
//    NSLog(@"select");
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Search"];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    //    request.sortDescriptors = @[sort];
    
    //排序 查找所有历史搜索
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    //    NSMutableArray *array2=[[NSMutableArray alloc]init];
    //
    //
    //        for(int i=0;i<array.count-1;i++)
    //        {
    //            Search *search = array[array.count-1-i];
    //            [array2 addObject:search];
    //        }
    //
    return array;
}
//删除某一个搜索
- (void)deleteOneTitle:(NSString *)title
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Search"];
    NSArray *array=[self.context executeFetchRequest:request error:nil];
    for (Search *search in array)
    {
        [self.context deleteObject:search];
    }
    [self.context save:nil];
}
//  清空所有历史搜索
- (void)deleteAllSearchModel
{
//    NSLog(@"delete");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Search"];
    
    NSArray *array=[self.context executeFetchRequest:request error:nil];
    
    for (Search *search in array) {
        [self.context deleteObject:search];
    }
    
    [self.context save:nil];
    
}
@end
