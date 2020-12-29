//
//  CategoriesManager.h
//  WallPaper
//
//  Created by Never on 2017/2/9.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoriesViewController.h"

@interface CategoriesManager : NSObject
//图片数组
@property(nonatomic,readonly)NSArray *categories;

+ (instancetype)shareManager;


@end
