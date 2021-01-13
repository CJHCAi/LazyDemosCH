//
//  YCNetManager.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^callBack)(NSError *error ,NSArray *pics);
@interface YCNetManager : NSObject

+ (void)getListPicsWithOrder:(NSString *)order
                        skip:(NSNumber *)skip
                    callBack:(callBack)callBack;

+ (void)getCategoryPicsWithCallBack:(callBack)callBack;

+ (void)getCategoryListWithTId:(NSString *)tId
                          skip:(NSNumber *)skip
                       callBack:(callBack)callBack;

+ (void)getHotSearchKeyWordsWithCallBack:(callBack)callBack;

+ (void)getSearchListWithKey:(NSString *)key
                        skip:(NSNumber *)skip
                    callBack:(callBack)callBack;

@end
