//
//  LEFriendDbManage.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "LEFriendDbManage.h"
#import "DatabaseToll.h"
@implementation LEFriendDbManage
-(void)insertWithFriendArray:(NSArray<HKFriendModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock{
    DatabaseToll*dbToll =   [DatabaseToll sharedDatabaseToll];
    [dbToll.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        @try {
            
            for ( int i =0;i< dataArray.count;i++) {
                HKFriendModel*dataModel=dataArray[i];
                BOOL isHas = YES;
                if (i == 0) {
                   isHas =  [dataModel isHasTable:db];
                }
                if (!isHas) {
                    sucBlock(NO);
                    return ;
                }
                if ([dataModel isExsistWithFieldArray:@[@"uid"] andDB:db ]) {
                    NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_update];
                    BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                    if (isSuc) {
                        DLog(@"修改数据成功");
                    }else{
                        *rollback = YES;
                    }
                }else{
                    NSString *sqlStr = [self getSqlString:dataModel withImplementType:implementType_insert];
                    BOOL isSuc =  [dbToll executeWithDB:db andUpdate:sqlStr];
                    if (isSuc) {
                        DLog(@"插入数据成功");
                    }else{
                        *rollback = YES;
                    }
                }
            }
            
        } @catch (NSException *exception) {
            *rollback = YES;
            [db rollback];
            sucBlock(NO);
        } @finally {
            if (!*rollback) {
                [db commit];
                sucBlock(YES);
            }else{
                [db rollback];
                //               DLog(@"%d",rollback);
            }
            
        }
    }];
    
}
@end
