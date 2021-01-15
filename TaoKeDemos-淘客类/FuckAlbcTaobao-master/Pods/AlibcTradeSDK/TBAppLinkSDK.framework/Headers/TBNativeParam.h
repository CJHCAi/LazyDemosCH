//
//  TBNativeParam.h
//  WopcMiniSDK
//
//  Created by muhuai on 15/8/18.
//  Copyright (c) 2015年 TaoBao. All rights reserved.
//

#import "TBBasicParam.h"

@interface TBNativeParam : TBBasicParam

/**
 *  要跳转的模块
 */
@property (nonatomic, strong) NSString     *moduleFromApp;

/**
 *  初始化,传入module
 */
-(instancetype)initWithModule:(NSString *)module;
@end
