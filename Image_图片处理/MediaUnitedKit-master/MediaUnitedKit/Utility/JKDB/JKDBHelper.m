//
//  JKDataBase.m
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
//

#import "JKDBHelper.h"
#import "JKDBModel.h"
#import <objc/runtime.h>

@interface JKDBHelper ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end

@implementation JKDBHelper

static JKDBHelper *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        if (_instance.dbQueue == nil) {
            _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self dbPath]];
        }
    }) ;
    
    return _instance;
}

- (BOOL)updateDBPath
{
    _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:[JKDBHelper dbPath]];
    
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);
    
    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_getSuperclass(classes[i]) == [JKDBModel class]){
                id class = classes[i];
                [class performSelector:@selector(createTable) withObject:nil];
            }
        }
        free(classes);
    }
    
    return YES;
}

+ (NSString *)dbPath
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docDir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docDir stringByAppendingPathComponent:@"database.sqlite"];
    return dbpath;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [JKDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [JKDBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}

#endif

+ (NSArray *)transients
{
    return [NSArray array];
}


@end
