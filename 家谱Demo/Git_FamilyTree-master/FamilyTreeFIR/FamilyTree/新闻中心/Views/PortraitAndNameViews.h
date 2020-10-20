//
//  PortraitAndNameViews.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyDTModel.h"

@interface PortraitAndNameViews : UIView
//@property (nonatomic,strong) NSArray *imageNames; /*图片数组*/
//@property (nonatomic,strong) NSArray *imageForName; /*图片人物*/
/** 名人传记数组*/
@property (nonatomic, strong) NSArray<FamilyDTModel *> *MRZJArr;

@end
