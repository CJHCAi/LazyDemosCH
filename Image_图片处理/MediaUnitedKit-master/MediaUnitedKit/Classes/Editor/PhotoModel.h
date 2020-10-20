//
//  PhotoModel.h
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/22.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  存储临时图片
//

#import "JKDBModel.h"

@interface PhotoModel : JKDBModel

// 文件名
@property (nonatomic,copy) NSString *fileName;
// 是否已经黑白化
@property (nonatomic,assign) BOOL isSketch;

@end
