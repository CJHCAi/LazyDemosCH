//
//  YSStaticSectionModel.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSStaticSectionModel.h"

@implementation YSStaticSectionModel

- (instancetype)initWithItemArray:(NSArray<YSStaticCellModel *> *)cellModelArray {
    if (self = [super init]) {
        _sectionHeaderHeight = 10;
        _sectionFooterHeight = 0;
        
        if (cellModelArray) {
            _cellModelArray = cellModelArray.mutableCopy;
        } else {
            _cellModelArray = [NSMutableArray array];
        }
    }
    return self;
}

+ (instancetype)sectionWithItemArray:(NSArray<YSStaticCellModel *> *)cellModelArray {
    return [[self alloc] initWithItemArray:cellModelArray];
}

@end
