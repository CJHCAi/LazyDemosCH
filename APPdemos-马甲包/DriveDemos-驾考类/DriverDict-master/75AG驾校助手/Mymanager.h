//
//  Mymanager.h
//  75AG驾校助手
//
//  Created by again on 16/3/30.
//  Copyright © 2016年 again. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    chapter,// 章节练习数据
    answer, //答题数据
    subChapter //专项
}DataType;
@interface Mymanager : NSObject
+ (NSArray *)getData:(DataType)type;
@end
