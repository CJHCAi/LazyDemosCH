//
//  YSAvatarModel.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSAvatarModel.h"
#import "YSAvatorCell.h"

@implementation YSAvatarModel

- (instancetype)init {
    if (self = [super init]) {
        self.cellHeight     = 80;
        self.cellIdentifier = @"avatorCell";
        // 请使用这种方法设置classname，不要使用字符串，防止类没加载
        // 导致调用NSClassFromstring 时 为 nil 报错
        self.cellClassName  = NSStringFromClass([YSAvatorCell class]);
        self.cellClassName = @"YSAvatorCell";
        self.cellType       = YSStaticCellTypeCustom;
    }
    return self;
}

@end
