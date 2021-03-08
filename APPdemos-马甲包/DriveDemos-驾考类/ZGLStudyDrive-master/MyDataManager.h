//
//  MyDataManager.h
//  StudyDrive
//
//  Created by zgl on 16/1/7.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    chapter,//章节练习数据
    answer,//答题数据
    subChapter//专项练习数据
    
}DataType;

@interface MyDataManager : NSObject

+(NSArray *)getData:(DataType)type;

@end
