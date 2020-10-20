//
//  FamilyModel.h
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Gender: NSInteger {
    female = 2,
    male = 1
} Gender;

@interface FamilyModel : NSObject
//性别
@property(nonatomic,assign) Gender gender;

@property (nonatomic,strong) NSString *pid;
//表示层级,选填
@property (nonatomic,assign) int level;
//这个人的名字
@property (nonatomic,strong) NSString *name;
//这个人的头像
@property (nonatomic,strong) NSString *avatar;
//这个人的ID
@property (nonatomic,strong) NSString *personId;
//称呼
@property (nonatomic,strong) NSString *appellation;
//生日
@property(nonatomic,copy) NSString *birthday;
//电话
@property (nonatomic,strong) NSString *tel;
//出生地
@property(nonatomic,copy) NSString *birthplace;
//配偶
@property(nonatomic,copy) NSArray<FamilyModel *> *mates;
//孩子
@property (nonatomic,strong) NSArray<FamilyModel *> *children;

@end
