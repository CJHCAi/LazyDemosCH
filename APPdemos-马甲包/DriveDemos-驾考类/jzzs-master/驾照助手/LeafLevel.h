//
//  LeafLevel.h
//  驾照助手
//
//  Created by 淡定独行 on 16/5/7.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeafLevel : NSObject

@property (nonatomic, copy  ) NSString  *mQuestion;  //问题
@property (nonatomic, copy  ) NSString  *mDesc; //解析
@property (nonatomic, assign) NSInteger mId;    //题目序号
@property (nonatomic, copy  ) NSString  *mAnswer;   //题目答案
@property (nonatomic, copy  ) NSString  *mImage;    //问题图片
@property (nonatomic, assign) NSInteger pId;    //题目类型id
@property (nonatomic, copy  ) NSString  *pName; //题目类型名称
@property (nonatomic, assign) NSInteger sId;    //
@property (nonatomic, strong) NSString  *sName;
@property (nonatomic, assign) NSInteger mStatus;
@property (nonatomic, copy  ) NSString  *mArea;
@property (nonatomic, assign) NSInteger mType;
@property (nonatomic, strong) NSString  *mUnknow;
@property (nonatomic, assign) NSInteger mYear;
@property (nonatomic, assign) NSInteger eCount;

@end
