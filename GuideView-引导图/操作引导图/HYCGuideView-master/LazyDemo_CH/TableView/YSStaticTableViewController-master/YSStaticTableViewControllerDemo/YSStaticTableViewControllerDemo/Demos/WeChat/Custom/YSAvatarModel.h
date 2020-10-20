//
//  YSAvatarModel.h
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSStaticCellModel.h"

@interface YSAvatarModel : YSStaticCellModel

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UIImage *codeImage;
@property (nonatomic, copy)   NSString *userName;
@property (nonatomic, copy)   NSString *userID;

@end
