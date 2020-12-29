//
//  YCDBManager.h
//  YClub
//
//  Created by yuepengfei on 17/5/17.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCDBManager : NSObject

+ (instancetype)shareInstance;
// 保存
- (BOOL)savePic:(YCBaseModel *)pic;
// 删除
- (BOOL)deletePic:(YCBaseModel *)pic;
// 获取
- (NSArray *)getAllPics;


+ (void)runBlockInBackground:(void (^)())block;
@end
