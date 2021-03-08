//
//  DataManger.h
//  DriverAssistant
//
//  Created by C on 16/3/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    chapter,    //章节练习数据
    answer,     //答题数据
    subChapter//专项练习
}DataType;
@interface DataManger : NSObject
+ (NSArray *)getData:(DataType)type;
@end
