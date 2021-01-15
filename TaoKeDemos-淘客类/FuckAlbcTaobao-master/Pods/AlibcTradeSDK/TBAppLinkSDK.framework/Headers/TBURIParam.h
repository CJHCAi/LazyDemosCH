//
//  TBH5Param.h
//  WopcMiniSDK
//
//  Created by muhuai on 15/8/18.
//  Copyright (c) 2015年 TaoBao. All rights reserved.
//

#import "TBBasicParam.h"

@interface TBURIParam : TBBasicParam

/**
 *  要跳转到的H5页面的url
 */
@property (nonatomic, strong) NSString *uri;

/**
 *  初始化,传入h5URL
 */
- (instancetype)initWithURI:(NSString *)URI;

@end
