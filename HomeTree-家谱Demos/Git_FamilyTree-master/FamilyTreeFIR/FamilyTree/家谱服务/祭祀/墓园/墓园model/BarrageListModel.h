//
//  BarrageListModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BarrageListDmModel;
@interface BarrageListModel : NSObject

@property (nonatomic, strong) NSArray<BarrageListDmModel *> *dm;

@property (nonatomic, strong) NSArray *js;

@end
@interface BarrageListDmModel : NSObject

@property (nonatomic, copy) NSString *BaContent;

@end

