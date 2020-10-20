//
//  FamilyModel.h
//  hire
//
//  Created by William on 16/6/16.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FamilyModel : NSObject

//表示层级,选填
@property (nonatomic,assign) int level;

//这个人的名称
@property (nonatomic,strong) NSString *name;

//子模型
@property (nonatomic,strong) FamilyModel *sunModel;

//绘图时需要用到的记录Fram
@property (nonatomic,assign) CGRect frame;

@end
