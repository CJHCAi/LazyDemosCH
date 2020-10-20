//
//  LineageCellView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineageModel.h"

@interface LineageCellView : UIView
/** 模型*/
@property (nonatomic, strong) LineageDatalistModel *model;
/** 姓名标签*/
@property (nonatomic, strong) UILabel *nameLB;

@end
