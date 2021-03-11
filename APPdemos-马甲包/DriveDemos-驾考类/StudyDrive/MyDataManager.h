//
//  MyDataManager.h
//  StudyDrive
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    chapter,//章节练习数据
    answer,//答题数据
    subChapter//专项
}DataType;
@interface MyDataManager : NSObject
+(NSArray *)getData:(DataType)type;
@end
