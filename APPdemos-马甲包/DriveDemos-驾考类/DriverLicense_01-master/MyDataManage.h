//
//  MyDataManage.h
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/10.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    chapter,//章节练习数据
    answer,//答题数据
    
}DataType;

@interface MyDataManage : NSObject
//类方法只是一个工具，不需要实例化对象
+(NSArray *)getData:(DataType) type;

@end
