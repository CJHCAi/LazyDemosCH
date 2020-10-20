//
//  TestModel.h
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TMSWIPE_FRIEND;  //备注 + 删除
extern NSString *const TMSWIPE_PUBLIC;  //取消关注 + 删除
extern NSString *const TMSWIPE_OTHERS;  //image + text

@interface TestModel : NSObject

@property (nonatomic, copy)NSString *headUrl;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *message_id;

+ (NSArray *)getAllDatas;

@end
