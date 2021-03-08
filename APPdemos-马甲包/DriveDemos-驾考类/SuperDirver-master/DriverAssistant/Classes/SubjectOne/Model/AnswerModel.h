//
//  AnswerModel.h
//  DriverAssistant
//
//  Created by C on 16/3/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
@property (nonatomic, copy) NSString *mquestion;
@property (nonatomic, copy) NSString *mdesc;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *manswer;
@property (nonatomic, copy) NSString *mimage;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *sname;
/**
 题目类型 1-选择题 2-判断题
 */
@property (nonatomic, copy) NSString *mtype;

@end
